import 'package:flutter/material.dart';
import '../services/donation_service.dart';

class SimpleDonationForm extends StatefulWidget {
  const SimpleDonationForm({super.key});

  @override
  State<SimpleDonationForm> createState() => _SimpleDonationFormState();
}

class _SimpleDonationFormState extends State<SimpleDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final _donationService = DonationService();
  
  final _foodNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();

  Future<void> _saveDonation() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _donationService.addDonation(
          _foodNameController.text,
          _descriptionController.text,
          int.parse(_quantityController.text),
          _locationController.text,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Donation')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _foodNameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter food name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter quantity' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter location' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveDonation,
              child: const Text('Save Donation'),
            ),
          ],
        ),
      ),
    );
  }
} 
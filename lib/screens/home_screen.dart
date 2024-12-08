import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/donation.dart';
import 'donation_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Donations'),
      ),
      body: StreamBuilder<List<Donation>>(
        stream: FirebaseService.getDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No donations yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final donations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              return Card(
                child: ListTile(
                  title: Text(donation.foodName),
                  subtitle: Text(donation.description),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Qty: ${donation.quantity}'),
                      Text(donation.pickupTime),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DonationForm()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
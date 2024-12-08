import 'package:flutter/material.dart';
import '../database/simple_db_helper.dart';
import '../models/simple_donation.dart';

class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodShare'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: SimpleDbHelper.getDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No donations yet'));
          }

          final donations = snapshot.data!
              .map((map) => SimpleDonation.fromMap(map))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              return Card(
                child: ListTile(
                  title: Text(donation.foodName),
                  subtitle: Text(donation.description),
                  trailing: Text('Qty: ${donation.quantity}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SimpleDonationForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/donation.dart';

class MyDonationsScreen extends StatelessWidget {
  const MyDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Donations'),
      ),
      body: StreamBuilder<List<Donation>>(
        stream: FirebaseService.getDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No donations yet'),
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
                  trailing: Text('Qty: ${donation.quantity}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../models/donation.dart';

class DonationDetailsScreen extends StatelessWidget {
  final Donation donation;

  const DonationDetailsScreen({
    super.key,
    required this.donation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              donation.foodName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      context,
                      'Description',
                      donation.description,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Quantity',
                      donation.quantity.toString(),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Location',
                      donation.location,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Pickup Time',
                      donation.pickupTime.toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!donation.isClaimed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement claim logic
                    _showClaimConfirmationDialog(context);
                  },
                  child: const Text('Claim Donation'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClaimConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Claim'),
          content: const Text(
            'Are you sure you want to claim this donation? '
            'You will be responsible for picking up the food at the specified time.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement claim confirmation logic
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
} 
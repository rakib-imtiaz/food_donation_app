import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green[700],
              ),
              title: Text('Past Donation #${index + 1}'),
              subtitle: Text('Completed on ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
            ),
          );
        },
      ),
    );
  }
} 
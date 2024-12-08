import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String _status = 'Connected to Firebase';
  bool _isLoading = false;
  List<Map<String, dynamic>> _testData = [];

  Future<void> _addTestData() async {
    setState(() {
      _isLoading = true;
      _status = 'Adding test data...';
    });

    try {
      print('Attempting to add data to Firestore...');
      
      // Create the data
      final data = {
        'foodName': 'fd',
        'description': 'ddddd',
        'quantity': 5,
        'timestamp': FieldValue.serverTimestamp(),
      };
      
      print('Data to add: $data');

      // Get Firestore instance
      final firestore = FirebaseFirestore.instance;
      print('Got Firestore instance');

      // Add the document
      final docRef = await firestore.collection('test_donations').add(data);
      print('Document added with ID: ${docRef.id}');

      setState(() {
        _status = 'Test data added successfully!';
      });
      
      // Refresh the data list
      await _loadTestData();
    } catch (e, stackTrace) {
      print('Error adding data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTestData() async {
    try {
      print('Loading data from Firestore...');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('test_donations')
          .get();

      setState(() {
        _testData = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
        print('Loaded ${_testData.length} documents');
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _status = 'Error loading data: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTestData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _status,
                      style: TextStyle(
                        color: _status.contains('Error') ? Colors.red : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addTestData,
                      child: Text(_isLoading ? 'Adding...' : 'Add Test Data'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Test Data:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _testData.length,
                itemBuilder: (context, index) {
                  final data = _testData[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(data['foodName'] ?? 'No name'),
                      subtitle: Text(data['description'] ?? 'No description'),
                      trailing: Text('Qty: ${data['quantity']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
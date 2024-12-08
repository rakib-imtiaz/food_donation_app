import 'package:cloud_firestore/cloud_firestore.dart';

class DonationService {
  final CollectionReference donations = 
      FirebaseFirestore.instance.collection('donations');

  // Add a donation
  Future<void> addDonation(String foodName, String description, 
      int quantity, String location) async {
    await donations.add({
      'foodName': foodName,
      'description': description,
      'quantity': quantity,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get all donations
  Stream<QuerySnapshot> getDonations() {
    return donations.orderBy('timestamp', descending: true).snapshots();
  }

  // Delete a donation
  Future<void> deleteDonation(String donationId) async {
    await donations.doc(donationId).delete();
  }
} 
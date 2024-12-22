import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'donations';

  static Future<void> addDonation(Donation donation) async {
    await _db.collection(_collection).doc(donation.id).set(donation.toMap());
  }

  static Stream<List<Donation>> getDonations() {
    return _db
        .collection(_collection)
        .orderBy('pickupTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Donation.fromMap(data);
            }).toList());
  }

  static Future<void> deleteDonation(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
} 
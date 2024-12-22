import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Sign Up
  static Future<UserCredential> signUp(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user profile in Firestore
      await _db.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'location': '',
        'createdAt': DateTime.now(),
      });

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign In
  static Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update Profile
  static Future<void> updateProfile({
    required String name,
    required String location,
    String? phone,
    String? address,
    String? bio,
  }) async {
    try {
      String uid = currentUser!.uid;
      await _db.collection('users').doc(uid).update({
        'name': name,
        'location': location,
        'phone': phone,
        'address': address,
        'bio': bio,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get User Profile
  static Stream<DocumentSnapshot> getUserProfile() {
    String uid = currentUser!.uid;
    return _db.collection('users').doc(uid).snapshots();
  }

  // Delete Account
  static Future<void> deleteAccount() async {
    try {
      String uid = currentUser!.uid;
      // Delete user data from Firestore
      await _db.collection('users').doc(uid).delete();
      // Delete user authentication
      await currentUser!.delete();
    } catch (e) {
      rethrow;
    }
  }
} 
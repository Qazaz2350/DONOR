import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrphanageFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===== Get current UID =====
  String? get uid => _auth.currentUser?.uid;

  // ===== Submit Orphanage Profile =====
  static Future<void> submitOrphanageProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String address,
    required List<String> needs,
  }) async {
    await _firestore.collection('orphanage').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'needs': needs,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ===== Load Orphanage Dashboard Data =====
  static Future<Map<String, dynamic>?> loadDashboardData(String uid) async {
    final doc = await _firestore.collection('orphanage').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  // ===== Create Donation Request =====
  static Future<void> createDonationRequest({
    required String uid,
    required String type,
    required int requiredQty,
    required String priority,
    DateTime? deadline,
    required String description,
  }) async {
    final docRef = _firestore
        .collection('orphanage')
        .doc(uid)
        .collection('requests')
        .doc();
    await docRef.set({
      'type': type,
      'requiredQuantity': requiredQty,
      'receivedQuantity': 0,
      'priority': priority,
      'deadline': deadline,
      'description': description,
      'status': 'Active',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ===== Load Donation Requests =====
  static Future<List<Map<String, dynamic>>> loadDonationRequests(
    String uid,
  ) async {
    final snap = await _firestore
        .collection('orphanage')
        .doc(uid)
        .collection('requests')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  // ===== Detect User Type =====
  static Future<String?> detectUserType(String uid) async {
    final donorDoc = await _firestore.collection('donor').doc(uid).get();
    if (donorDoc.exists) return 'donor';

    final orphanageDoc = await _firestore
        .collection('orphanage')
        .doc(uid)
        .get();
    if (orphanageDoc.exists) return 'orphanage';

    return null;
  }

  // ===== Firebase Auth SignIn =====
  static Future<User?> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // ===== Firebase Auth SignUp =====
  static Future<User?> signUp(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OrphanageFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ===== Get current UID =====
  String? get uid => _auth.currentUser?.uid;

  // ===== Submit Orphanage Profile =====
  static Future<void> submitOrphanageProfile({
    required String name,
    required String uid,
    required String address,
    String? cnic,
    File? cnicImage,
    File? signboardImage,
    File? orphanageImage,
    String? status,
    double? latitude,
    double? longitude,
  }) async {
    // Upload images if provided
    String? cnicUrl;
    String? signboardUrl;
    String? orphanageUrl;

    if (cnicImage != null) {
      final ref = _storage.ref('orphanages/$uid/cnic.jpg');
      await ref.putFile(cnicImage);
      cnicUrl = await ref.getDownloadURL();
    }

    if (signboardImage != null) {
      final ref = _storage.ref('orphanages/$uid/signboard.jpg');
      await ref.putFile(signboardImage);
      signboardUrl = await ref.getDownloadURL();
    }

    if (orphanageImage != null) {
      final ref = _storage.ref('orphanages/$uid/orphanage.jpg');
      await ref.putFile(orphanageImage);
      orphanageUrl = await ref.getDownloadURL();
    }

    // Save to Firestore
    await _firestore.collection('orphanage').doc(uid).set({
      'orphanageaddress': address,
      'cnic': cnic,
      'orphanagename': name,

      'cnicImage': cnicUrl,
      'signBoardImage': signboardUrl,
      'orphanageImage': orphanageUrl,
      'status': status ?? "pending",
      'createdAt': FieldValue.serverTimestamp(),
      "latitude": latitude,
      "longitude": longitude,
    }, SetOptions(merge: true));
  }

  // ===== Submit OFFD Orphanage Profile =====
  static Future<void> submitOffdOrphanageProfile({
    required String uid,

    required List<String> needs,

    File? cnicImage,
    File? signboardImage,
    File? orphanageImage,
    List<String>? images,
    List<Map<String, dynamic>>? stories,
    List<Map<String, dynamic>>? volunteeringEvents,
    bool verified = false,
    // String? status,
  }) async {
    String? cnicUrl, signboardUrl, orphanageUrl;

    if (cnicImage != null) {
      final ref = _storage.ref('orphanages/$uid/cnic.jpg');
      await ref.putFile(cnicImage);
      cnicUrl = await ref.getDownloadURL();
    }

    if (signboardImage != null) {
      final ref = _storage.ref('orphanages/$uid/signboard.jpg');
      await ref.putFile(signboardImage);
      signboardUrl = await ref.getDownloadURL();
    }

    if (orphanageImage != null) {
      final ref = _storage.ref('orphanages/$uid/orphanage.jpg');
      await ref.putFile(orphanageImage);
      orphanageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('orphanage').doc(uid).set({
      'needs': needs,

      'signBoardImage': signboardUrl,
      'cnicImage': cnicUrl,
      'orphanageImage': orphanageUrl,
      'additionalImages': images ?? [],
      'stories': stories ?? [],
      'volunteeringEvents': volunteeringEvents ?? [],
      'verified': verified,
      // 'status': status ?? "pending",
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> fetchOrphanageProfile({
    required String uid,
  }) async {
    try {
      final doc = await _firestore.collection('orphanage').doc(uid).get();
      if (doc.exists) {
        return doc.data(); // Returns the orphanage data as a Map
      } else {
        return null; // No orphanage found for this UID
      }
    } catch (e) {
      print('Error fetching orphanage profile: $e');
      return null;
    }
  }

  // fetch orphangae signin
  Future<List<Map<String, dynamic>>> fetchAllOrphanages() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orphanage')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'uid': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Fetch orphanages error: $e');
      return [];
    }
  }

  // ===== Fetch CURRENT Signed-in Orphanage Profile (ALL FIELDS) =====
  static Future<Map<String, dynamic>?> fetchCurrentOrphanageProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final doc = await _firestore.collection('orphanage').doc(uid).get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      print('Fetched Orphanage Address: ${data['orphanageaddress']}');

      // Return ALL relevant fields
      return {
        'uid': doc.id,
        'fullName': data['orphanagename'] ?? '',
        'email': data['email'] ?? '',
        'phone': data['phone'] ?? '',
        'address': data['orphanageaddress'] ?? '',

        'status': data['status'] ?? '',
        'cnic': data['cnic'] ?? '',
        'cnicImage': data['cnicImage'] ?? '',
        'signBoardImage': data['signBoardImage'] ?? '',
        'orphanageImage': data['orphanageImage'] ?? '',
        'needs': List<String>.from(data['needs'] ?? []),
        'additionalImages': List<String>.from(data['additionalImages'] ?? []),
        'stories': List<Map<String, dynamic>>.from(data['stories'] ?? []),
        'volunteeringEvents': List<Map<String, dynamic>>.from(
          data['volunteeringEvents'] ?? [],
        ),
        'verified': data['verified'] ?? false,
        'latitude': data['latitude'] ?? 0.0,
        'longitude': data['longitude'] ?? 0.0,
        'createdAt': data['createdAt'] ?? null,
      };
    } catch (e) {
      print('Fetch current orphanage profile error: $e');
      return null;
    }
  }
}

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
}

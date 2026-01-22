import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> orphanages = [];
  List<Map<String, dynamic>> donors = [];
  List<Map<String, dynamic>> adminActions = [];
  bool isLoading = false;

  // 🔹 FETCH USERS AND ACTIONS
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch orphanages
      final orphanageSnap = await _firestore.collection('orphanage').get();

      orphanages = orphanageSnap.docs
          .map((doc) {
            final data = doc.data();

            return {
              'id': doc.id,

              // Signup data
              'fullName': data['fullName'] ?? '',
              'email': data['email'] ?? '',
              'phone': data['phone'] ?? '',

              // Orphanage profile data
              'address': data['orphanageaddress'] ?? '',
              'cnic': data['cnic'] ?? '',
              'profile': List<String>.from(data['Orphanageprofile'] ?? []),

              // Images
              'cnicImage': data['cnicImage'] ?? '',
              'signboardImage': data['signBoardImage'] ?? '',
              'orphanageImage': data['orphanageImage'] ?? '',

              // Status
              'status': data['status'] ?? 'OrphanageFormPending',
            };
          })
          // 🔹 SHOW ONLY THOSE WHO SUBMITTED CNIC
          .where((o) => (o['cnic'] as String).isNotEmpty)
          .toList();

      // Fetch donors
      final donorSnap = await _firestore.collection('donor').get();
      donors = donorSnap.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'fullName': data['fullName'] ?? '',
          'email': data['email'] ?? '',
          'phone': data['phone'] ?? '',
        };
      }).toList();

      // Fetch admin actions
      final actionSnap = await _firestore
          .collection('adminactions')
          .orderBy('timestamp', descending: true)
          .get();

      adminActions = actionSnap.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching users or actions: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔹 APPROVE / REJECT ORPHANAGE
  Future<void> setAdminApproval({
    required String orphanageId,
    required bool approve,
  }) async {
    try {
      final orphanage = orphanages.firstWhere((o) => o['id'] == orphanageId);

      final newStatus = approve ? 'accepted' : 'rejected';

      // Update orphanage status
      await _firestore.collection('orphanage').doc(orphanageId).update({
        'status': newStatus,
      });

      // Log admin action
      await _firestore.collection('adminactions').add({
        'orphanageId': orphanageId,
        'orphanageName': orphanage['fullName'],
        'action': newStatus,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await fetchUsers(); // refresh
    } catch (e) {
      debugPrint('Error setting admin status: $e');
    }
  }
}

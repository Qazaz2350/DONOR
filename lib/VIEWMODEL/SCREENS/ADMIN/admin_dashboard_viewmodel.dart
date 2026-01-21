import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> orphanages = [];
  List<Map<String, dynamic>> donors = [];
  List<Map<String, dynamic>> adminActions = []; // 🔹 History
  bool isLoading = false;

  // 🔹 FETCH USERS AND ACTIONS
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch orphanages
      final orphanageSnap = await _firestore.collection('orphanage').get();
      orphanages = orphanageSnap.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'fullName': data['fullName'] ?? '',
          'email': data['email'] ?? '',
          'phone': data['phone'] ?? '',
          'address': data['address'] ?? '',
          'cnic': data['cnic'] ?? '',
          'profile': List<String>.from(data['Orphanageprofile'] ?? []),
          'status': data['status'] ?? 'OrphanageFormPending',
          'cnicImage': data['cnicImage'] ?? '',
          'signboardImage': data['signboardImage'] ?? '',
          'orphanageImage': data['orphanageImage'] ?? '',
        };
      }).toList();

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

      // 🔹 Fetch admin actions for History tab
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

  // 🔹 SET ADMIN STATUS AND LOG ACTION
  Future<void> setAdminApproval({
    required String orphanageId,
    required bool approve, // true = approve, false = reject
  }) async {
    try {
      final orphanage = orphanages.firstWhere((o) => o['id'] == orphanageId);

      // Update orphanage status
      await _firestore.collection('orphanage').doc(orphanageId).update({
        'status': approve ? 'Approved' : 'Rejected',
      });

      // Log admin action
      await _firestore.collection('adminactions').add({
        'orphanageId': orphanageId,
        'orphanageName': orphanage['fullName'],
        'action': approve ? 'Approved' : 'Rejected',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await fetchUsers(); // refresh list
    } catch (e) {
      debugPrint('Error setting admin status: $e');
    }
  }
}

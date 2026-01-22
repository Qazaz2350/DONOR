// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class OrphanageService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> fetchAcceptedOrphanages() async {
//     try {
//       final snapshot = await _firestore
//           .collection('orphanage')
//           .where('status', isEqualTo: 'accepted')
//           .get();

//       return snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();
//     } catch (e) {
//       debugPrint('Error fetching orphanages: $e');
//       return [];
//     }
//   }
// }

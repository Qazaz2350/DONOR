// import 'package:cloud_firestore/cloud_firestore.dart';

// class DonorFirebaseService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch all approved orphanages
//   static Future<List<Map<String, dynamic>>> fetchApprovedOrphanages() async {
//     try {
//       final snap = await _firestore
//           .collection('orphanage')
//           .where('status', isEqualTo: 'Approved')
//           .get();

//       return snap.docs.map((doc) {
//         final data = doc.data();
//         return {
//           'id': doc.id,
//           'name': data['orphanagename'] ?? '',
//           'address': data['orphanageaddress'] ?? '',
//           'cnic': data['cnic'] ?? '',
//           'profile': List<String>.from(data['needs'] ?? []),
//           'cnicImage': data['cnicImage'] ?? '',
//           'signboardImage': data['signBoardImage'] ?? '',
//           'orphanageImage': data['orphanageImage'] ?? '',
//           'additionalImages': data['additionalImages'] ?? [],
//           'stories': data['stories'] ?? [],
//           'volunteeringEvents': data['volunteeringEvents'] ?? [],
//           'verified': data['verified'] ?? false,
//         };
//       }).toList();
//     } catch (e) {
//       print('Error fetching approved orphanages: $e');
//       return [];
//     }
//   }
// }

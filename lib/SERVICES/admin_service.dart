import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllOrphanageProfiles() async {
    List<Map<String, dynamic>> profiles = [];

    try {
      // 1️⃣ Get all orphanages
      QuerySnapshot orphanagesSnap = await _firestore
          .collection('orphanage')
          .get();

      for (var doc in orphanagesSnap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final uid = doc.id;

        // 2️⃣ Add main orphanage data if needed
        profiles.add({
          'uid': uid,
          'offd_fullname': data['offd_fullname'] ?? '',
          'offd_email': data['offd_email'] ?? '',
          'offd_phone': data['offd_phone'] ?? '',
          'offd_address': data['offd_address'] ?? '',
          'offd_needs': data['offd_needs'] ?? [],
          'offd_status': data['offd_status'] ?? 'pending',
          'offd_verified': data['offd_verified'] ?? false,
          'offd_cnicImage': data['offd_cnicImage'] ?? '',
          'offd_signBoardImage': data['offd_signBoardImage'] ?? '',
          'offd_orphanageImage': data['offd_orphanageImage'] ?? '',
        });
        // print('profiles: $profiles');
      }
    } catch (e) {
      print('Error fetching orphanage profiles: $e');
    }

    return profiles;
  }
}

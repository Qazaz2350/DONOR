import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDonation({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required DonationModel donation,
  }) async {
    final docRef = _firestore.collection('donations').doc(userId);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      // 🟢 User already exists → update same doc
      await docRef.update({
        'donorname': name,
        'donoremail': email,
        'donorphone': phone,
        'donations': FieldValue.arrayUnion([donation.toMap()]),
      });
    } else {
      // 🔵 New user → create new doc
      await docRef.set({
        'donorname': name,
        'donoremail': email,
        'donorphone': phone,
        'donations': [donation.toMap()],
      });
    }
  }

  // ================= ADD VIDEO CALL REQUEST =================
  Future<void> addVideoCallRequest({
    required DateTime scheduledDateTime,
    String? orphanageName,
    required String donorName,
    required String donorPhone,
    required String donorEmail,
  }) async {
    try {
      await _firestore.collection('videocallrequest').add({
        'scheduledTime': Timestamp.fromDate(scheduledDateTime),
        'orphanageName': orphanageName?.isNotEmpty == true
            ? orphanageName
            : 'No Name',
        'donorName': donorName,
        'donorPhone': donorPhone,
        'donorEmail': donorEmail,
        'videocallstatus': 'pending',
        'requestTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw e;
    }
  }
}

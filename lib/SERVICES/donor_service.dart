import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a donation to Firestore
  Future<void> addDonation({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required DonationModel donation,
  }) async {
    final docRef = _firestore.collection('donations').doc(userId);
    final snapshot = await docRef.get();

    final donationMap = donation.toMap();

    if (snapshot.exists) {
      // Append donation to existing document
      await docRef.update({
        'donorname': name,
        'donoremail': email,
        'donorphone': phone,
        'donations': FieldValue.arrayUnion([donationMap]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } else {
      // Create a new document for this user
      await docRef.set({
        'userId': userId,
        'donorname': name,
        'donoremail': email,
        'donorphone': phone,
        'donations': [donationMap],
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Fetch user donations
  Future<List<DonationModel>> fetchUserDonations(String userId) async {
    final doc = await _firestore.collection('donations').doc(userId).get();

    if (!doc.exists) return [];

    final donations = (doc.data()?['donations'] as List<dynamic>?) ?? [];
    return donations
        .map((d) => DonationModel.fromMap(Map<String, dynamic>.from(d)))
        .toList();
  }

  /// Submit a video call request
  Future<void> addVideoCallRequest({
    required String donorId,
    required String donorName,
    required String donorPhone,
    required String donorEmail,
    required String orphanageId,
    required String orphanageName,
    required DateTime scheduledTime,
  }) async {
    final callID = '$donorId\_$orphanageId';
    await _firestore.collection('videocallrequest').add({
      'callID': callID,
      'donorID': donorId,
      'orphanageID': orphanageId,
      'orphanageName': orphanageName,
      'donorName': donorName,
      'donorPhone': donorPhone,
      'donorEmail': donorEmail,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'requestTime': FieldValue.serverTimestamp(),
      'videocallstatus': 'pending',
    });
  }

  /// Fetch all video call requests
  Future<List<Map<String, dynamic>>> fetchVideoCallRequests() async {
    final snapshot = await _firestore
        .collection('videocallrequest')
        .orderBy('requestTime', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }
}

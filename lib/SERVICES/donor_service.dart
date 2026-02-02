import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ---------------------------
  /// DONATION OPERATIONS (EXISTING)
  /// ---------------------------

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

  /// ---------------------------
  /// VIDEO CALL OPERATIONS (EXISTING)
  /// ---------------------------

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

  /// ---------------------------
  /// NEW: ORPHANAGE OPERATIONS
  /// ---------------------------

  /// Fetch all accepted orphanages
  Future<List<Map<String, dynamic>>> fetchAcceptedOrphanages() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orphanage')
          .where('status', isEqualTo: 'accepted')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// ---------------------------
  /// NEW: VIDEO CALL MANAGEMENT
  /// ---------------------------

  /// Create active call document
  Future<void> createActiveCall({
    required String callID,
    required String donorId,
    required String donorName,
    required String orphanageId,
    required String orphanageName,
    required String? requestId,
  }) async {
    await _firestore.collection('active_calls').doc(callID).set({
      'callID': callID,
      'donorId': donorId,
      'donorName': donorName,
      'orphanageId': orphanageId,
      'orphanageName': orphanageName,
      'startTime': DateTime.now(),
      'status': 'active',
      'requestId': requestId,
    });
  }

  /// End active call
  Future<void> endActiveCall(String callID) async {
    await _firestore.collection('active_calls').doc(callID).update({
      'status': 'ended',
      'endTime': DateTime.now(),
    });
  }

  /// Stream active calls for donor
  Stream<QuerySnapshot> getActiveCallsStream(String donorId) {
    return _firestore
        .collection('active_calls')
        .where('donorId', isEqualTo: donorId)
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  /// Fetch donor data by UID
  Future<Map<String, dynamic>> getDonorData(String donorId) async {
    final doc = await _firestore.collection('donor').doc(donorId).get();
    return doc.data() ?? {};
  }

  /// ---------------------------
  /// NEW: UTILITY METHODS
  /// ---------------------------

  /// Generate unique call ID
  String generateCallID({
    required String donorId,
    required String orphanageId,
    bool withTimestamp = false,
  }) {
    if (withTimestamp) {
      return 'call_${donorId}_${orphanageId}_${DateTime.now().millisecondsSinceEpoch}';
    }
    return '${donorId}_${orphanageId}';
  }

  /// Get active call by ID
  Future<Map<String, dynamic>?> getActiveCall(String callID) async {
    final doc = await _firestore.collection('active_calls').doc(callID).get();
    if (doc.exists) {
      final data = doc.data();
      data?['id'] = doc.id;
      return data;
    }
    return null;
  }

  /// Get video call request by ID
  Future<Map<String, dynamic>?> getVideoCallRequest(String requestId) async {
    final doc = await _firestore
        .collection('videocallrequest')
        .doc(requestId)
        .get();
    if (doc.exists) {
      final data = doc.data();
      data?['id'] = doc.id;
      return data;
    }
    return null;
  }

  /// Delete video call request
  Future<void> deleteVideoCallRequest(String requestId) async {
    await _firestore.collection('videocallrequest').doc(requestId).delete();
  }

  /// Update donation document
  Future<void> updateDonation({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore.collection('donations').doc(userId).update(updates);
  }

  /// Get donation document
  Future<Map<String, dynamic>?> getDonationDocument(String userId) async {
    final doc = await _firestore.collection('donations').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      data?['id'] = doc.id;
      return data;
    }
    return null;
  }

  /// Check if orphanage exists and is accepted
  Future<bool> isOrphanageAccepted(String orphanageId) async {
    try {
      final doc = await _firestore
          .collection('orphanage')
          .doc(orphanageId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        return data?['status'] == 'accepted';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get orphanage details
  Future<Map<String, dynamic>?> getOrphanageDetails(String orphanageId) async {
    try {
      final doc = await _firestore
          .collection('orphanage')
          .doc(orphanageId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        data?['uid'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

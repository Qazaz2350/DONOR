// view_models/donor_viewmodel.dart
import 'package:donate/SERVICES/donor_service.dart';
import 'package:donate/VIEW/zegocloud/zego_CallPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class DonorViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DonationService _donationService = DonationService();

  /// ---------------------------
  /// DONATION LOGIC
  /// ---------------------------
  List<DonationModel> userDonations = [];
  bool isFetchingDonations = false;
  String? donationError;

  /// Fetch user donations from Firestore
  Future<void> fetchUserDonations() async {
    isFetchingDonations = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        donationError = 'User not logged in';
        return;
      }

      final docSnapshot = await _firestore
          .collection('donations')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final List<dynamic> donationsArray = data['donations'] ?? [];

        userDonations = donationsArray.map((donationMap) {
          return DonationModel.fromMap(Map<String, dynamic>.from(donationMap));
        }).toList();

        donationError = null;
      } else {
        userDonations = [];
        donationError = null;
      }
    } catch (e) {
      donationError = e.toString();
      debugPrint('Error fetching donations: $e');
    } finally {
      isFetchingDonations = false;
      notifyListeners();
    }
  }

  /// Save a new donation
  Future<void> donateNow({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required Map<String, dynamic> orphanageData,
    required String category,
    required String amount,
    required String quantity,
    required String notes,
  }) async {
    final donation = DonationModel(
      foundationId: orphanageData['uid'] ?? '',
      foundationName:
          orphanageData['orphanagename'] ?? orphanageData['name'] ?? '',
      category: category,
      amount: category == 'Money' ? double.tryParse(amount) : null,
      quantity: category != 'Money' ? int.tryParse(quantity) : null,
      notes: notes,
      timestamp: DateTime.now(),
    );

    await _donationService.addDonation(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      donation: donation,
    );

    userDonations.insert(0, donation);
    notifyListeners();
  }

  /// Handle donation button press
  Future<void> handleDonateButton({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required Map<String, dynamic> orphanageData,
    required String category,
    required TextEditingController amountController,
    required TextEditingController quantityController,
    required TextEditingController notesController,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }

      if (category == 'Money') {
        final amount = double.tryParse(amountController.text) ?? 0;
        if (amount <= 0) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
          return;
        }
      } else {
        if (quantityController.text.isEmpty ||
            int.tryParse(quantityController.text) == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Enter valid quantity')));
          return;
        }
      }

      await donateNow(
        userId: user.uid,
        name: name,
        email: email,
        phone: phone,
        orphanageData: orphanageData,
        category: category,
        amount: amountController.text,
        quantity: quantityController.text,
        notes: notesController.text,
      );

      amountController.clear();
      quantityController.clear();
      notesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation Successful'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  /// ---------------------------
  /// ORPHANAGE LOGIC
  /// ---------------------------
  List<Map<String, dynamic>> acceptedOrphanages = [];
  bool isFetchingOrphanages = false;
  String? orphanageError;

  Future<void> fetchAcceptedOrphanages() async {
    isFetchingOrphanages = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orphanage')
          .where('status', isEqualTo: 'accepted')
          .get();

      acceptedOrphanages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      orphanageError = e.toString();
    }

    isFetchingOrphanages = false;
    notifyListeners();
  }

  /// ---------------------------
  /// VIDEO CALL LOGIC
  /// ---------------------------
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  TimeOfDay? selectedTime;
  final TextEditingController timeController = TextEditingController();

  List<Map<String, dynamic>> videoCallRequests = [];
  bool isFetchingVideoCalls = false;

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }

  Future<void> submitVideoCall({
    required BuildContext context,
    required Map<String, dynamic> orphanageData,
    required String donorName,
    required String donorPhone,
    required String donorEmail,
  }) async {
    final orphanageName =
        orphanageData['orphanagename'] ?? orphanageData['name'] ?? 'No Name';

    if (selectedDay == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    final scheduledDateTime = DateTime(
      selectedDay!.year,
      selectedDay!.month,
      selectedDay!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final callID = "${user.uid}_${orphanageData['uid']}";

    try {
      await _firestore.collection('videocallrequest').add({
        'callID': callID,
        'donorID': user.uid,
        'orphanageID': orphanageData['uid'],
        'orphanageName': orphanageName,
        'donorName': donorName,
        'donorPhone': donorPhone,
        'donorEmail': donorEmail,
        'scheduledTime': Timestamp.fromDate(scheduledDateTime),
        'requestTime': FieldValue.serverTimestamp(),
        'videocallstatus': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video call request sent successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> fetchVideoCallRequests() async {
    isFetchingVideoCalls = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      QuerySnapshot snapshot;

      try {
        // Try with ordering first
        snapshot = await _firestore
            .collection('videocallrequest')
            .where('donorID', isEqualTo: user.uid)
            .orderBy('requestTime', descending: true)
            .get();
      } catch (e) {
        // If fails, try without ordering
        snapshot = await _firestore
            .collection('videocallrequest')
            .where('donorID', isEqualTo: user.uid)
            .get();
      }

      videoCallRequests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      debugPrint('Fetch error: $e');
      videoCallRequests = [];
    }

    isFetchingVideoCalls = false;
    notifyListeners();
  }

  /// ---------------------------
  /// VIDEO CALL ACTIONS
  /// ---------------------------
  Future<void> startVideoCall({
    required BuildContext context,
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please login first')));
        return;
      }

      final donorDoc = await _firestore
          .collection('donor')
          .doc(currentUser.uid)
          .get();

      final donorData = donorDoc.data() ?? {};
      final donorName =
          donorData['fullName'] ??
          currentUser.displayName ??
          currentUser.email?.split('@').first ??
          'Donor';

      final orphanageName = requestData['orphanageName'] ?? 'Orphanage';
      final orphanageId = requestData['orphanageID'];
      final callID =
          requestData['callID'] ??
          'call_${currentUser.uid}_${orphanageId}_${DateTime.now().millisecondsSinceEpoch}';

      if (requestData['id'] != null) {
        await _firestore
            .collection('videocallrequest')
            .doc(requestData['id'])
            .update({
              'videocallstatus': 'active',
              'actualCallStartTime': FieldValue.serverTimestamp(),
            });
      }

      await _firestore.collection('active_calls').doc(callID).set({
        'callID': callID,
        'donorId': currentUser.uid,
        'donorName': donorName,
        'orphanageId': orphanageId,
        'orphanageName': orphanageName,
        'startTime': DateTime.now(),
        'status': 'active',
        'requestId': requestData['id'],
      });
      print("✅ Active call created with ID: $orphanageId, $orphanageName");

      if (context.mounted) {
        ZegoUIKitPrebuiltCallInvitationService().send(
          invitees: [ZegoCallUser(orphanageId, orphanageName)],
          isVideoCall: false,
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CallPage(
        //       callID: callID,
        //       userID: currentUser.uid,
        //       userName: donorName,
        //     ),
        //   ),
        // );
      }
    } catch (e) {
      debugPrint('Error starting video call: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to start call: $e')));
      }
    }
  }

  Stream<QuerySnapshot> getActiveCallsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('active_calls')
        .where('donorId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  Future<void> endVideoCall(String callID) async {
    try {
      await _firestore.collection('active_calls').doc(callID).update({
        'status': 'ended',
        'endTime': DateTime.now(),
      });

      final callDoc = await _firestore
          .collection('active_calls')
          .doc(callID)
          .get();
      final requestId = callDoc.data()?['requestId'];

      if (requestId != null) {
        await _firestore.collection('videocallrequest').doc(requestId).update({
          'videocallstatus': 'completed',
          'callEndTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error ending video call: $e');
    }
  }
}

import 'package:donate/SERVICES/donor_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';

class DonorViewModel extends ChangeNotifier {
  /// ---------------------------
  /// GREETING
  /// ---------------------------
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// ---------------------------
  /// DONOR STATS
  /// ---------------------------
  double _totalDonations = 1250.0;
  int _donationCount = 12;
  int _childrenSponsored = 3;

  double get totalDonations => _totalDonations;
  int get donationCount => _donationCount;
  int get childrenSponsored => _childrenSponsored;

  String get formattedTotalDonations {
    if (_totalDonations >= 1000) {
      return '\$${(_totalDonations / 1000).toStringAsFixed(1)}k';
    }
    return '\$${_totalDonations.toStringAsFixed(0)}';
  }

  String get donationCountText => '$_donationCount Donations';
  String get childrenSponsoredText => '$_childrenSponsored Children';

  /// ---------------------------
  /// FIRESTORE ORPHANAGE LOGIC
  /// ---------------------------
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  /// DONATION LOGIC
  /// ---------------------------

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

    await DonationService().addDonation(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      donation: donation,
    );
  }

  /// ---------------------------
  /// BUTTON HANDLER
  /// ---------------------------

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
      final user = FirebaseAuth.instance.currentUser;

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
        if (quantityController.text.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Enter quantity')));
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

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  TimeOfDay? selectedTime;
  final TextEditingController timeController = TextEditingController();
  final DonationService _donationService = DonationService();
  // ===== Select Date =====
  void onDateSelected(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }
  // ===== Submit Video Call Request =====
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

    final scheduledDateTime = DateTime(
      selectedDay!.year,
      selectedDay!.month,
      selectedDay!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    try {
      await _donationService.addVideoCallRequest(
        scheduledDateTime: scheduledDateTime,
        orphanageName: orphanageName,
        donorName: donorName,
        donorPhone: donorPhone,
        donorEmail: donorEmail,
      );

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

  List<Map<String, dynamic>> videoCallRequests = [];
  bool isFetchingVideoCalls = false;

  // ===== Fetch Video Call Requests =====
  Future<void> fetchVideoCallRequests() async {
    isFetchingVideoCalls = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('videocallrequest')
          .orderBy('requestTime', descending: true)
          .get();

      videoCallRequests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching video call requests: $e');
    }

    isFetchingVideoCalls = false;
    notifyListeners();
  }
}

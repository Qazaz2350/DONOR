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
    // Prepare the donation model with all fields
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

    // Call service to save donation
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

      // Validate inputs
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

      // Save donation
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

      // Clear controllers
      amountController.clear();
      quantityController.clear();
      notesController.clear();

      // Success message
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

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final scheduledDateTime = DateTime(
      selectedDay!.year,
      selectedDay!.month,
      selectedDay!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    /// 🔹 Unique & SAME callID for both users
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

  // video start button
  // Future<void> logCallStart(String docID) async {
  //   await _firestore.collection('videocallrequest').doc(docID).update({
  //     'callStartedAt': FieldValue.serverTimestamp(),
  //     'callStatus': 'ongoing',
  //   });
  // }

  //call end

  // Future<void> logCallEnd(String docID, DateTime startTime) async {
  //   final endTime = DateTime.now();
  //   final duration = endTime.difference(startTime).inSeconds;

  //   await _firestore.collection('videocallrequest').doc(docID).update({
  //     'callEndedAt': FieldValue.serverTimestamp(),
  //     'callDuration': duration,
  //     'callStatus': 'ended',
  //   });
  // }

  // start video call

  List<Map<String, dynamic>> videoCallRequests = [];
  bool isFetchingVideoCalls = false;

  // ===== Fetch Video Call Requests =====
  Future<void> fetchVideoCallRequests() async {
    isFetchingVideoCalls = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('videocallrequest')
          .orderBy('requestTime', descending: true)
          .get();

      // Convert Firestore documents to a list of maps
      videoCallRequests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // store doc ID for reference
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching video call requests: $e');
    }

    isFetchingVideoCalls = false;
    notifyListeners();
  }

  /// ---------------------------
  /// FETCH USER DONATIONS FROM FIRESTORE
  ///
  List<DonationModel> userDonations = [];
  bool isFetchingDonations = false;
  String? donationError;

  /// ---------------------------
  /// FETCH USER DONATIONS FROM FIRESTORE
  /// ---------------------------
  Future<void> fetchUserDonations() async {
    isFetchingDonations = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        donationError = 'User not logged in';
        return;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final List<dynamic> donationsArray = data['donations'] ?? [];

        // Convert each map in the array to DonationModel
        userDonations = donationsArray.map((donationMap) {
          return DonationModel.fromMap(Map<String, dynamic>.from(donationMap));
        }).toList();

        donationError = null;
      } else {
        // No document exists for this user
        userDonations = [];
        donationError = null;
      }

      // Optional: print for debug
      // for (var d in userDonations) {
      //   print('------------------------');
      //   print('Foundation: ${d.foundationName}');
      //   print('Category: ${d.category}');
      //   print('Amount: ${d.amount}');
      //   print('Quantity: ${d.quantity}');
      //   print('Notes: ${d.notes}');
      //   print('Time: ${d.timestamp}');
      // }
    } catch (e) {
      donationError = e.toString();
      debugPrint('Error fetching donations: $e');
    } finally {
      isFetchingDonations = false;
      notifyListeners();
    }
  }
  // ======================
  // KIND DNA PROFILE / BADGE SYSTEM
  // ======================

  // XP, Rank & Badges
  int _xp = 0;
  String _rank = 'Beginner';
  List<String> _badges = [];

  int get xp => _xp;
  String get rank => _rank;
  List<String> get badges => _badges;

  /// ---------------------------
  /// CALCULATE BADGES & RANK
  /// ---------------------------
  void calculateBadges() {
    _xp = 0;
    _badges = [];

    for (var donation in userDonations) {
      // XP based on donation type
      if (donation.category == 'Money' && donation.amount != null) {
        _xp += (donation.amount! / 10).round() * 2; // 2 XP per $10
      } else if (donation.quantity != null) {
        _xp += donation.quantity! * 5; // 5 XP per item
      }

      // Badges based on category
      if (donation.category == 'Toys' && !_badges.contains('Toy Giver')) {
        _badges.add('Toy Giver');
      }
      if (donation.category == 'Education' &&
          !_badges.contains('Education Sponsor')) {
        _badges.add('Education Sponsor');
      }
      if (donation.category == 'Money' && !_badges.contains('Philanthropist')) {
        _badges.add('Philanthropist');
      }
    }

    // Frequency-based badges
    if (userDonations.length >= 5 && !_badges.contains('Regular Donor')) {
      _badges.add('Regular Donor');
    }
    if (userDonations.length >= 10 && !_badges.contains('Hero Donor')) {
      _badges.add('Hero Donor');
    }

    // Assign rank based on XP
    if (_xp >= 500) {
      _rank = 'Champion';
    } else if (_xp >= 250) {
      _rank = 'Advanced';
    } else if (_xp >= 100) {
      _rank = 'Intermediate';
    } else {
      _rank = 'Beginner';
    }

    notifyListeners();
  }

  /// ---------------------------
  /// SAVE BADGES & RANK TO FIRESTORE
  /// ---------------------------
  Future<void> saveBadgesToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('donations').doc(user.uid).update({
        'xp': _xp,
        'rank': _rank,
        'badges': _badges,
      });
    } catch (e) {
      debugPrint('Error saving badges: $e');
    }
  }

  /// ---------------------------
  /// REFRESH BADGES AFTER FETCHING DONATIONS
  /// ---------------------------
  Future<void> updateBadges() async {
    calculateBadges();
    await saveBadgesToFirebase();
  }
}

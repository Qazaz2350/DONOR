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
  /// DONATION HISTORY (MOCK)
  /// ---------------------------
  final List<Donation> donationHistory = [
    Donation(
      type: "Money",
      orphanageName: "Sunshine Orphanage",
      amount: 1000,
      status: "Delivered",
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Donation(
      type: "Books",
      orphanageName: "Hope Orphanage",
      status: "Shipped",
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Donation(
      type: "Food",
      orphanageName: "Bright Future Orphanage",
      status: "Pending",
      date: DateTime.now(),
    ),
    Donation(
      type: "Toys",
      orphanageName: "Happy Kids Orphanage",
      status: "Delivered",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<Donation> filterDonationsByStatus(String status) {
    return donationHistory.where((d) => d.status == status).toList();
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

  Future<void> fetchDonorStats() async {
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  /// ---------------------------
  /// FIRESTORE ORPHANAGE LOGIC (from testing)
  /// ---------------------------
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> acceptedOrphanages = [];
  bool isFetchingOrphanages = false;
  String? orphanageError;

  Future<void> fetchAcceptedOrphanages() async {
    isFetchingOrphanages = true;
    orphanageError = null;
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
      orphanageError = 'Error fetching orphanages: $e';
      acceptedOrphanages = [];
    }

    isFetchingOrphanages = false;
    notifyListeners();
  }
}

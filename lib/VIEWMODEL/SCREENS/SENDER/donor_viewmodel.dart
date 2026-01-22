import 'package:flutter/material.dart';
import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';
import 'package:donate/SERVICES/admin_service.dart';

class DonorViewModel extends ChangeNotifier {
  final AdminService _adminService = AdminService();

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
  /// OFFD ORPHANAGES (ADMIN SERVICE)
  /// ---------------------------
  bool isOffdLoading = false;
  List<Map<String, dynamic>> offdOrphanages = [];

  /// ---------------------------
  /// Fetch all orphanage profiles
  /// ---------------------------
  Future<void> fetchOffdOrphanages() async {
    isOffdLoading = true;
    notifyListeners();

    try {
      offdOrphanages = await _adminService.fetchAllOrphanageProfiles();
      print("offdOrphanages: $offdOrphanages");
    } catch (e) {
      print('Error fetching orphanages: $e');
      offdOrphanages = [];
    }

    isOffdLoading = false;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/SERVICES/orphanage_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';

class OrphanageViewModel extends ChangeNotifier {
  // ===== Form Controllers (existing) =====
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // ===== Needs (existing) =====
  Map<String, bool> needs = {
    'Food': false,
    'Clothes': false,
    'Books': false,
    'Toys': false,
    'Education': false,
  };

  void toggleNeed(String need, bool value) {
    needs[need] = value;
    notifyListeners();
  }

  // ===== UID (existing) =====
  String? _uid;
  String? get uid {
    if (_uid != null) return _uid;
    _uid = FirebaseAuth.instance.currentUser?.uid;
    return _uid;
  }

  // ===== Form ORPHANAGE Validation (existing) ===== WAITING FOR ADMIN APPROVE
  final formKey = GlobalKey<FormState>();
  bool validateForm() => formKey.currentState?.validate() ?? false;

  // ===== Dashboard State (existing) =====
  double totalRequiredDonation = 0;
  double totalReceivedDonation = 0;
  int foodRemaining = 0;
  int clothesRemaining = 0;
  int educationPending = 0;
  bool isUrgent = false;
  bool isVerified = false;
  DateTime? verifiedDate;
  int childrenBenefitedThisMonth = 0;

  double get donationProgress => totalRequiredDonation == 0
      ? 0
      : totalReceivedDonation / totalRequiredDonation;

  double get remainingDonation => totalRequiredDonation - totalReceivedDonation;

  // ===== Load Dashboard Data =====
  Future<void> loadDashboardData() async {
    final currentUid = uid;
    if (currentUid == null) return;

    final data = await OrphanageFirebaseService.loadDashboardData(currentUid);
    if (data == null) return;

    totalRequiredDonation = (data['totalRequiredDonation'] ?? 0).toDouble();
    totalReceivedDonation = (data['totalReceivedDonation'] ?? 0).toDouble();
    foodRemaining = data['foodRemaining'] ?? 0;
    clothesRemaining = data['clothesRemaining'] ?? 0;
    educationPending = data['educationPending'] ?? 0;
    isUrgent = data['isUrgent'] ?? false;
    isVerified = data['status'] == 'verified';
    verifiedDate = (data['verifiedDate'] as Timestamp?)?.toDate();
    childrenBenefitedThisMonth = data['childrenBenefitedThisMonth'] ?? 0;

    notifyListeners();
  }

  // ===== Submit Orphanage Profile =====
  Future<void> submitOrphanage(BuildContext context) async {
    bool isVerified = false;
    final currentUid = uid;
    if (currentUid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not signed in')));
      return;
    }

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    List<String> selectedNeeds = needs.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    try {
      await OrphanageFirebaseService.submitOrphanageProfile(
        uid: currentUid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        needs: selectedNeeds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Orphanage profile submitted for verification'),
        ),
      );
      // Nav.push(context, OrphanageDashboardView());
      isVerified = true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ===== Donation Requests =====
  List<DonationRequest> requests = [];

  Future<void> createDonationRequest({
    required String type,
    required int requiredQty,
    required String priority,
    DateTime? deadline,
    required String description,
  }) async {
    final currentUid = uid;
    if (currentUid == null) return;

    await OrphanageFirebaseService.createDonationRequest(
      uid: currentUid,
      type: type,
      requiredQty: requiredQty,
      priority: priority,
      deadline: deadline,
      description: description,
    );

    // Add locally
    final docId = DateTime.now().millisecondsSinceEpoch.toString();
    final request = DonationRequest(
      id: docId,
      type: type,
      requiredQuantity: requiredQty,
      priority: priority,
      deadline: deadline,
      description: description,
    );
    requests.add(request);
    notifyListeners();
  }

  Future<void> loadRequests() async {
    final currentUid = uid;
    if (currentUid == null) return;

    final dataList = await OrphanageFirebaseService.loadDonationRequests(
      currentUid,
    );

    requests = dataList.map((data) {
      return DonationRequest(
        id: data['id'],
        type: data['type'],
        requiredQuantity: data['requiredQuantity'],
        receivedQuantity: data['receivedQuantity'],
        priority: data['priority'],
        deadline: (data['deadline'] as Timestamp?)?.toDate(),
        description: data['description'],
        status: data['status'],
      );
    }).toList();

    notifyListeners();
  }

  // ===== Stats =====
  int get activeRequests => requests.where((r) => r.status == 'Active').length;
  int get completedRequests =>
      requests.where((r) => r.status == 'Completed').length;
  int get pendingRequests =>
      requests.where((r) => r.status != 'Completed').length;

  // ===== Helper Functions =====
  IconData getNeedIcon(String type) {
    switch (type.toLowerCase()) {
      case 'money':
        return Icons.attach_money;
      case 'food':
        return Icons.food_bank;
      case 'clothes':
        return Icons.checkroom;
      case 'education':
        return Icons.menu_book;
      case 'wish item':
        return Icons.card_giftcard;
      default:
        return Icons.help_outline;
    }
  }

  Color getDonationColor(String type) {
    switch (type.toLowerCase()) {
      case 'money':
        return Colors.green;
      case 'food':
        return Colors.orange;
      case 'clothes':
        return Colors.blue;
      case 'education':
        return Colors.purple;
      case 'wish item':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  int totalRequestsQuantity() =>
      requests.fold(0, (sum, r) => sum + r.requiredQuantity);

  int totalCompletedQuantity() => requests
      .where((r) => r.status == 'Completed')
      .fold(0, (sum, r) => sum + r.receivedQuantity);

  // =========================
  // ===== New Form Fields =====
  // =========================

  final TextEditingController imageController = TextEditingController();
  final TextEditingController needController = TextEditingController();

  List<String> images = [];
  List<String> additionalNeeds = [];
  Map<String, int> donationStock = {};

  List<Map<String, dynamic>> donationHistory = [];
  List<Map<String, dynamic>> stories = [];
  List<Map<String, dynamic>> volunteeringEvents = [];
  String arThankYouMarker = '';
  bool verified = false;

  void addImage() {
    if (imageController.text.isNotEmpty) {
      images.add(imageController.text);
      imageController.clear();
      notifyListeners();
    }
  }

  void addAdditionalNeed() {
    if (needController.text.isNotEmpty) {
      additionalNeeds.add(needController.text);
      donationStock[needController.text] = 0;
      needController.clear();
      notifyListeners();
    }
  }

  void addDonationHistory() {
    donationHistory.add({
      'donorId': '',
      'type': '',
      'quantity': 0,
      'amount': 0.0,
      'date': DateTime.now(),
    });
    notifyListeners();
  }

  void addStory() {
    stories.add({
      'title': '',
      'content': '',
      'images': <String>[],
      'date': DateTime.now(),
    });
    notifyListeners();
  }

  void addEvent() {
    volunteeringEvents.add({
      'id': '',
      'title': '',
      'description': '',
      'date': DateTime.now(),
      'capacity': 0,
      'registered': 0,
    });
    notifyListeners();
  }

  void toggleVerified(bool val) {
    verified = val;
    notifyListeners();
  }
}

// ===== DonationRequest model (unchanged) =====
class DonationRequest {
  String id;
  String type;
  int requiredQuantity;
  int receivedQuantity;
  String priority;
  DateTime? deadline;
  String description;
  String status;

  DonationRequest({
    required this.id,
    required this.type,
    required this.requiredQuantity,
    this.receivedQuantity = 0,
    required this.priority,
    this.deadline,
    required this.description,
    this.status = 'Active',
  });
}

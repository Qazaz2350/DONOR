import 'package:image_picker/image_picker.dart';

class OrphanageModel {
  // 🔹 BASIC INFO (existing)
  String name;
  String email;
  String phone;
  String address;

  List<String> needs; // ['Food', 'Clothes', ...]
  List<XFile> images;
  List<XFile> documents;

  // 🔹 DASHBOARD DATA (added)
  double totalRequiredDonation;
  double totalReceivedDonation;

  int foodRemaining;
  int clothesRemaining;
  int educationPending;

  bool isUrgent;
  bool isVerified;
  DateTime? verifiedDate;

  int childrenBenefitedThisMonth;

  OrphanageModel({
    // existing
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.needs,
    required this.images,
    required this.documents,

    // dashboard
    required this.totalRequiredDonation,
    required this.totalReceivedDonation,
    required this.foodRemaining,
    required this.clothesRemaining,
    required this.educationPending,
    required this.isUrgent,
    required this.isVerified,
    this.verifiedDate,
    required this.childrenBenefitedThisMonth,
  });

  // 🔹 COMPUTED VALUES
  double get donationProgress => totalRequiredDonation == 0
      ? 0
      : totalReceivedDonation / totalRequiredDonation;

  double get remainingDonation => totalRequiredDonation - totalReceivedDonation;

  Map<String, dynamic> toJson() {
    return {
      // basic info
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'needs': needs,
      'images': images.map((e) => e.path).toList(),
      'documents': documents.map((e) => e.path).toList(),

      // dashboard
      'totalRequiredDonation': totalRequiredDonation,
      'totalReceivedDonation': totalReceivedDonation,
      'foodRemaining': foodRemaining,
      'clothesRemaining': clothesRemaining,
      'educationPending': educationPending,
      'isUrgent': isUrgent,
      'isVerified': isVerified,
      'verifiedDate': verifiedDate?.toIso8601String(),
      'childrenBenefitedThisMonth': childrenBenefitedThisMonth,
    };
  }
}

class DonationRequest {
  String id;
  String type; // Money, Food, Clothes, Education, Wish
  int requiredQuantity;
  int receivedQuantity;
  String priority; // Low, Medium, Urgent
  DateTime? deadline;
  String description;
  List<String> images;
  String status; // Active, Partial, Completed

  DonationRequest({
    required this.id,
    required this.type,
    required this.requiredQuantity,
    this.receivedQuantity = 0,
    required this.priority,
    this.deadline,
    required this.description,
    this.images = const [],
    this.status = 'Active',
  });

  double get progress =>
      requiredQuantity == 0 ? 0 : receivedQuantity / requiredQuantity;
}

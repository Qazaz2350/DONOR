import 'package:donate/MODELS/SCREENS/DONOR/MYDONATION_model.dart';
import 'package:flutter/material.dart';
import 'package:donate/UTILIS/app_colors.dart';

class DonorViewModel extends ChangeNotifier {
  /// ---------------------------
  /// EXISTING (DO NOT TOUCH)
  /// ---------------------------

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// ---------------------------
  /// DONATION PAGE
  /// ---------------------------
  String selectedCategory = 'Money';
  bool isRecurring = false;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  void toggleRecurring(bool value) {
    isRecurring = value;
    notifyListeners();
  }

  IconData getCategoryIcon(String category) {
    final icons = {
      'Money': Icons.attach_money_rounded,
      'Food': Icons.restaurant_rounded,
      'Clothes': Icons.checkroom_rounded,
      'Books': Icons.menu_book_rounded,
      'Toys': Icons.toys_rounded,
    };
    return icons[category] ?? Icons.volunteer_activism;
  }

  bool isAmountValid() {
    final amount = double.tryParse(amountController.text) ?? 0;
    return amount > 0;
  }

  double get amount => double.tryParse(amountController.text) ?? 0;

  /// ---------------------------
  /// ORPHANAGE DETAIL LOGIC
  /// ---------------------------
  IconData getNeedIcon(String need) {
    switch (need.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'clothes':
        return Icons.checkroom;
      case 'books':
        return Icons.menu_book;
      case 'toys':
        return Icons.toys;
      case 'shoes':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  IconData getDonationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'money':
        return Icons.attach_money;
      case 'clothes':
        return Icons.checkroom;
      case 'books':
        return Icons.menu_book;
      case 'toys':
        return Icons.toys;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.card_giftcard;
    }
  }

  Color getDonationColor(String type) {
    switch (type.toLowerCase()) {
      case 'money':
        return Colors.green;
      case 'clothes':
        return Colors.purple;
      case 'books':
        return Colors.blue;
      case 'toys':
        return Colors.orange;
      case 'food':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  /// ---------------------------
  /// DONATION HISTORY LOGIC MERGED
  /// ---------------------------
  final List<Donation> donationHistory = [
    Donation(
      type: "Money",
      orphanageName: "Sunshine Orphanage",
      amount: 1000,
      status: "Delivered",
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Donation(
      type: "Books",
      orphanageName: "Hope Orphanage",
      status: "Shipped",
      date: DateTime.now().subtract(Duration(days: 2)),
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
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  List<Donation> filterDonationsByStatus(String status) {
    return donationHistory.where((d) => d.status == status).toList();
  }

  @override
  void dispose() {
    amountController.dispose();
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

/// ---------------------------
/// DONATION MODEL
/// ---------------------------

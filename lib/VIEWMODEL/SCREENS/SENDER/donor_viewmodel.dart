import 'package:flutter/material.dart';
import 'package:donate/MODELS/SCREENS/DONOR/orphanage_model.dart';
import 'package:donate/UTILIS/app_colors.dart';

class Donorviewmodel extends ChangeNotifier {
  /// ---------------------------
  /// EXISTING (DO NOT TOUCH)
  /// ---------------------------
  bool isWelcomeExpanded = false;

  void toggleWelcome() {
    isWelcomeExpanded = !isWelcomeExpanded;
    notifyListeners();
  }

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

  /// Change donation category
  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  /// Toggle recurring donation
  void toggleRecurring(bool value) {
    isRecurring = value;
    notifyListeners();
  }

  /// Category icons
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

  /// Validation
  bool isAmountValid() {
    final amount = double.tryParse(amountController.text) ?? 0;
    return amount > 0;
  }

  double get amount => double.tryParse(amountController.text) ?? 0;

  @override
  void dispose() {
    amountController.dispose();
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

/// ---------------------------
/// ORPHANAGE DETAIL VIEWMODEL
/// ---------------------------
class OrphanageDetailViewModel {
  final OrphanageModel orphanage;

  OrphanageDetailViewModel(this.orphanage);

  /// Get icon for a need
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

  /// Get icon for a donation type
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

  /// Get color for a donation type
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
}

import 'package:flutter/material.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  // Scaffold Key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Selected menu index
  int selectedIndex = 0;

  // Menu items
  final List<String> menuItems = [
    'Dashboard',
    'Users',
    'Donations',
    'Clothes',
    'Cash',
    'Challenges',
    'Reminders',
    'Analytics',
    'Settings',
    'Logout',
  ];

  // Menu icons
  final List<IconData> menuIcons = [
    Icons.dashboard_rounded,
    Icons.people_rounded,
    Icons.volunteer_activism_rounded,
    Icons.checkroom_rounded,
    Icons.attach_money_rounded,
    Icons.emoji_events_rounded,
    Icons.access_time_rounded,
    Icons.analytics_rounded,
    Icons.settings_rounded,
    Icons.logout_rounded,
  ];

  // Update selected index
  void selectMenu(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

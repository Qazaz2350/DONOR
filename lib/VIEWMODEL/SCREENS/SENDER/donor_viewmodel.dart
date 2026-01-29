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

    // 🔥 NEW: Add to local list and update gamification
    userDonations.insert(0, donation);
    _calculateXPForDonation(donation);
    _checkBadgesForDonation(donation);
    _calculateWeeklyStreak();
    await _saveGamificationData();
    notifyListeners();
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

        // 🔥 NEW: Initialize gamification after fetching donations
        await _initializeGamification();
      } else {
        // No document exists for this user
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

  /// ===========================
  /// GAMIFICATION & BADGES LOGIC - FIXED VERSION
  /// ===========================
  // XP & Level System
  int xp = 0;
  int level = 1;
  String rank = 'Bronze';
  List<String> badges = [];

  // Leaderboards
  List<Map<String, dynamic>> globalLeaderboard = [];
  List<Map<String, dynamic>> friendLeaderboard = [];
  int weeklyStreak = 0;

  // Event & Seasonal Challenges
  final List<String> seasonalBadges = [
    'Ramadan Donation Hero 🕌',
    'Christmas Giver 🎄',
    'Independence Day Supporter 🇵🇰',
  ];

  // Donor Cards / Collectibles
  List<Map<String, dynamic>> donorCards = [];

  // XP thresholds for levels (extended)
  final Map<int, int> levelThresholds = {
    1: 0,
    2: 100,
    3: 250,
    4: 500,
    5: 1000,
    6: 2000,
    7: 4000,
    8: 8000,
    9: 15000,
    10: 30000,
  };

  /// 🔥 NEW: Initialize gamification when fetching donations
  Future<void> _initializeGamification() async {
    // Load saved gamification data from Firestore
    await _loadGamificationData();

    // Calculate stats from existing donations
    _calculateGamificationFromDonations();

    notifyListeners();
  }

  /// 🔥 NEW: Load gamification data from Firestore
  Future<void> _loadGamificationData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('user_gamification')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        xp = data['xp'] ?? 0;
        level = data['level'] ?? 1;
        rank = data['rank'] ?? 'Bronze';
        badges = List<String>.from(data['badges'] ?? []);
        weeklyStreak = data['weeklyStreak'] ?? 0;
        donorCards = List<Map<String, dynamic>>.from(data['donorCards'] ?? []);
      }
    } catch (e) {
      debugPrint('Error loading gamification data: $e');
    }
  }

  /// 🔥 NEW: Calculate gamification stats from donations
  void _calculateGamificationFromDonations() {
    if (userDonations.isEmpty) return;

    // Reset to defaults for recalculation
    int totalXP = 0;
    List<String> earnedBadges = [];
    Map<String, int> categoryCounts = {};

    // Calculate from all donations
    for (var donation in userDonations) {
      // Calculate XP
      totalXP += _calculateSingleDonationXP(donation);

      // Track category counts for badges
      final category = donation.category ?? 'Other';
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;

      // Check for badges
      earnedBadges.addAll(_getBadgesForSingleDonation(donation));

      // Add to donor cards
      donorCards.add({
        'category': donation.category,
        'amount': donation.amount ?? 0,
        'quantity': donation.quantity ?? 0,
        'timestamp': donation.timestamp,
        'foundationName': donation.foundationName,
      });
    }

    // Update XP
    xp = totalXP;

    // Add category-based badges
    for (var entry in categoryCounts.entries) {
      earnedBadges.addAll(_getCategoryBadges(entry.key, entry.value));
    }

    // Update badges (avoid duplicates)
    badges = [...badges, ...earnedBadges].toSet().toList();

    // Calculate level
    level = _calculateLevelFromXP(xp);

    // Update rank
    rank = _calculateRankFromLevel(level);

    // Calculate weekly streak
    weeklyStreak = _calculateWeeklyStreakCount();

    // Check micro-milestones
    _checkMicroMilestones();
  }

  /// 🔥 NEW: Calculate XP for a single donation
  int _calculateSingleDonationXP(DonationModel donation) {
    int earnedXP = 0;

    // Money donations: 1 XP per Rs 10
    if (donation.amount != null) {
      earnedXP += (donation.amount! / 10).ceil();
    }

    // Item donations: 2 XP per item
    if (donation.quantity != null) {
      earnedXP += donation.quantity! * 2;
    }

    // Category bonuses
    switch (donation.category?.toLowerCase()) {
      case 'money':
        earnedXP += 5; // Bonus for money donations
        break;
      case 'education':
        earnedXP += 10; // Extra bonus for education
        break;
      case 'food':
        earnedXP += 3; // Small bonus for food
        break;
      case 'toys':
        earnedXP += 2; // Bonus for toys
        break;
      case 'clothes':
        earnedXP += 2; // Bonus for clothes
        break;
    }

    return earnedXP;
  }

  /// 🔥 NEW: Calculate XP for donation (used in donateNow)
  void _calculateXPForDonation(DonationModel donation) {
    xp += _calculateSingleDonationXP(donation);
    _checkLevelUp();
  }

  /// 🔥 NEW: Get badges for a donation
  List<String> _getBadgesForSingleDonation(DonationModel donation) {
    List<String> donationBadges = [];
    final category = donation.category?.toLowerCase();
    final amount = donation.amount;
    final quantity = donation.quantity;
    final timestamp = donation.timestamp;

    // First donation
    if (userDonations.indexOf(donation) == 0) {
      donationBadges.add('First Step 👣');
    }

    // Amount milestones
    if (amount != null) {
      if (amount >= 1000) donationBadges.add('K+ Donor 💰');
      if (amount >= 5000) donationBadges.add('Major Donor 💎');
      if (amount >= 10000) donationBadges.add('Philanthropist 🏛️');
    }

    // Quantity milestones
    if (quantity != null && quantity >= 10) {
      donationBadges.add('Bulk Donor 📦');
    }

    // Seasonal badges
    if (timestamp.month == 12 && timestamp.day <= 25) {
      donationBadges.add('Christmas Giver 🎄');
    }
    if (timestamp.month == 4 && timestamp.day <= 10) {
      donationBadges.add('Ramadan Donation Hero 🕌');
    }
    if (timestamp.month == 8 && timestamp.day == 14) {
      donationBadges.add('Independence Day Supporter 🇵🇰');
    }

    return donationBadges;
  }

  /// 🔥 NEW: Check badges for donation (used in donateNow)
  void _checkBadgesForDonation(DonationModel donation) {
    final newBadges = _getBadgesForSingleDonation(donation);
    for (var badge in newBadges) {
      if (!badges.contains(badge)) {
        badges.add(badge);
      }
    }

    // Update category counts for badge evolution
    final categoryKey = donation.category ?? 'Other';
    int categoryCount = userDonations
        .where((d) => d.category == categoryKey)
        .length;

    final categoryBadges = _getCategoryBadges(categoryKey, categoryCount);
    for (var badge in categoryBadges) {
      if (!badges.contains(badge)) {
        badges.add(badge);
      }
    }
  }

  /// 🔥 NEW: Get category-specific badges
  List<String> _getCategoryBadges(String category, int count) {
    List<String> categoryBadges = [];
    final lowerCategory = category.toLowerCase();

    if (lowerCategory == 'toys') {
      if (count >= 5) categoryBadges.add('Toy Giver 🧸');
      if (count >= 10) categoryBadges.add('Toy Master 🎯');
      if (count >= 25) categoryBadges.add('Toy Legend 🏆');
    }

    if (lowerCategory == 'education') {
      if (count >= 3) categoryBadges.add('Education Sponsor 📚');
      if (count >= 10) categoryBadges.add('Education Champion 🎓');
    }

    if (lowerCategory == 'food') {
      if (count >= 5) categoryBadges.add('Food Provider 🍎');
      if (count >= 10) categoryBadges.add('Food Hero 🍲');
    }

    if (lowerCategory == 'clothes') {
      if (count >= 5) categoryBadges.add('Warm Hearts ❤️');
      if (count >= 10) categoryBadges.add('Fashion Giver 👕');
    }

    if (lowerCategory == 'money') {
      if (count >= 3) categoryBadges.add('Financial Supporter 💵');
      if (count >= 10) categoryBadges.add('Money Maven 💰');
    }

    return categoryBadges;
  }

  /// 🔥 NEW: Calculate level from XP
  int _calculateLevelFromXP(int xp) {
    int calculatedLevel = 1;

    for (var entry in levelThresholds.entries) {
      if (xp >= entry.value) {
        calculatedLevel = entry.key;
      }
    }

    return calculatedLevel;
  }

  /// 🔥 NEW: Check level up
  void _checkLevelUp() {
    int newLevel = _calculateLevelFromXP(xp);

    if (newLevel > level) {
      level = newLevel;
      badges.add('Level $level Achiever 🏆');
      _updateRank();
    }
  }

  /// 🔥 NEW: Calculate rank from level
  String _calculateRankFromLevel(int level) {
    if (level <= 3) return 'Bronze';
    if (level <= 6) return 'Silver';
    if (level <= 9) return 'Gold';
    return 'Platinum';
  }

  /// 🔥 NEW: Update rank
  void _updateRank() {
    rank = _calculateRankFromLevel(level);
  }

  /// 🔥 NEW: Calculate weekly streak count
  int _calculateWeeklyStreakCount() {
    if (userDonations.isEmpty) return 0;

    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 1,
    );

    // Count donations from this week
    int streak = 0;
    for (var donation in userDonations) {
      if (donation.timestamp.isAfter(startOfWeek)) {
        streak++;
      }
    }

    return streak;
  }

  /// 🔥 NEW: Calculate weekly streak (used in donateNow)
  void _calculateWeeklyStreak() {
    weeklyStreak = _calculateWeeklyStreakCount();
  }

  /// 🔥 NEW: Save gamification data to Firestore
  Future<void> _saveGamificationData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _firestore.collection('user_gamification').doc(user.uid).set({
        'xp': xp,
        'level': level,
        'rank': rank,
        'badges': badges,
        'weeklyStreak': weeklyStreak,
        'donorCards': donorCards,
        'totalDonations': userDonations.length,
        'lastUpdated': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userEmail': user.email,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving gamification data: $e');
    }
  }

  /// 🔥 NEW: Get XP progress percentage (0.0 to 1.0)
  double get xpProgress {
    final currentThreshold = levelThresholds[level] ?? 0;
    final nextLevel = level + 1;
    final nextThreshold =
        levelThresholds[nextLevel] ?? (currentThreshold + 1000);

    if (nextThreshold <= currentThreshold) return 1.0;

    final xpInCurrentLevel = xp - currentThreshold;
    final xpNeededForNextLevel = nextThreshold - currentThreshold;

    return (xpInCurrentLevel / xpNeededForNextLevel).clamp(0.0, 1.0);
  }

  /// 🔥 NEW: Get XP needed for next level
  int get xpToNextLevel {
    final currentThreshold = levelThresholds[level] ?? 0;
    final nextLevel = level + 1;
    final nextThreshold =
        levelThresholds[nextLevel] ?? (currentThreshold + 1000);

    return (nextThreshold - xp).clamp(0, nextThreshold);
  }

  /// 🔥 NEW: Get level thresholds list
  List<Map<String, dynamic>> get levelProgressData {
    return levelThresholds.entries.map((entry) {
      return {
        'level': entry.key,
        'xpRequired': entry.value,
        'unlocked': xp >= entry.value,
      };
    }).toList();
  }

  /// ===== Enhanced Micro Milestones =====
  void checkMicroMilestones() {
    // First donation
    if (userDonations.isNotEmpty && !badges.contains('Welcome Gift 🎁')) {
      badges.add('Welcome Gift 🎁');
    }

    // Donation count milestones
    final donationCount = userDonations.length;
    if (donationCount >= 3 && !badges.contains('Weekly Starter 🏁')) {
      badges.add('Weekly Starter 🏁');
    }
    if (donationCount >= 10 && !badges.contains('Consistent Giver 🔄')) {
      badges.add('Consistent Giver 🔄');
    }
    if (donationCount >= 25 && !badges.contains('Dedicated Donor 💫')) {
      badges.add('Dedicated Donor 💫');
    }
    if (donationCount >= 50 && !badges.contains('Legendary Giver 🌟')) {
      badges.add('Legendary Giver 🌟');
    }

    // Total items donated
    int totalItems = userDonations.fold(0, (sum, d) => sum + (d.quantity ?? 0));
    if (totalItems >= 50 && !badges.contains('Collector 🗃️')) {
      badges.add('Collector 🗃️');
    }
    if (totalItems >= 100 && !badges.contains('Super Collector 📦')) {
      badges.add('Super Collector 📦');
    }
    if (totalItems >= 250 && !badges.contains('Ultimate Collector 🏆')) {
      badges.add('Ultimate Collector 🏆');
    }

    // Total amount donated
    double totalAmount = userDonations.fold(
      0.0,
      (sum, d) => sum + (d.amount ?? 0),
    );
    if (totalAmount >= 5000 && !badges.contains('Generous Heart ❤️')) {
      badges.add('Generous Heart ❤️');
    }
    if (totalAmount >= 10000 && !badges.contains('Angel Donor 👼')) {
      badges.add('Angel Donor 👼');
    }

    // Category variety
    final categories = userDonations.map((d) => d.category ?? '').toSet();
    if (categories.length >= 3 && !badges.contains('Diverse Giver 🌈')) {
      badges.add('Diverse Giver 🌈');
    }
    if (categories.length >= 5 && !badges.contains('Universal Donor 🌍')) {
      badges.add('Universal Donor 🌍');
    }

    // Call save to update in Firestore
    _saveGamificationData();
  }

  /// 🔥 NEW: Internal micro-milestones check
  void _checkMicroMilestones() {
    // First donation
    if (userDonations.isNotEmpty && !badges.contains('Welcome Gift 🎁')) {
      badges.add('Welcome Gift 🎁');
    }

    // Donation count milestones
    final donationCount = userDonations.length;
    if (donationCount >= 3 && !badges.contains('Weekly Starter 🏁')) {
      badges.add('Weekly Starter 🏁');
    }
    if (donationCount >= 10 && !badges.contains('Consistent Giver 🔄')) {
      badges.add('Consistent Giver 🔄');
    }

    // Total items donated
    int totalItems = userDonations.fold(0, (sum, d) => sum + (d.quantity ?? 0));
    if (totalItems >= 100 && !badges.contains('Collector 🗃️')) {
      badges.add('Collector 🗃️');
    }
  }

  /// ===== Enhanced Leaderboards =====
  Future<void> fetchGlobalLeaderboard() async {
    try {
      final snapshot = await _firestore
          .collection('user_gamification')
          .orderBy('xp', descending: true)
          .limit(50)
          .get();

      globalLeaderboard = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'name': data['userEmail']?.toString().split('@').first ?? 'Anonymous',
          'xp': data['xp'] ?? 0,
          'level': data['level'] ?? 1,
          'rank': data['rank'] ?? 'Bronze',
          'badgeCount': (data['badges'] as List?)?.length ?? 0,
          'totalDonations': data['totalDonations'] ?? 0,
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching global leaderboard: $e');
    }
  }

  /// ===== Weekly Streak Methods =====
  void updateWeeklyStreak(bool donatedToday) {
    if (donatedToday) {
      weeklyStreak++;
    } else {
      weeklyStreak = 0;
    }
    _saveGamificationData();
    notifyListeners();
  }

  /// ===== Share Badges / Social =====
  void shareBadges() {
    // TODO: integrate Share package to share badge list
    debugPrint('Sharing badges: ${badges.join(', ')}');
  }

  /// ===== Donation Combos =====
  void checkDonationCombo(String category) {
    // Example: Donate multiple categories in a week → combo badge
    if (category == 'Money' && badges.contains('Toy Giver')) {
      _addBadge('Combo Donor 🏅');
    }
  }

  /// ===== Reset Weekly Leaderboard =====
  void resetWeeklyLeaderboard() {
    weeklyStreak = 0;
    _saveGamificationData();
    notifyListeners();
  }

  /// 🔥 NEW: Get user's position in leaderboard
  int get leaderboardPosition {
    if (globalLeaderboard.isEmpty) return 0;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    for (int i = 0; i < globalLeaderboard.length; i++) {
      if (globalLeaderboard[i]['userId'] == user.uid) {
        return i + 1;
      }
    }

    return 0;
  }

  /// 🔥 NEW: Get next rank info
  Map<String, dynamic> get nextRankInfo {
    final nextLevel = level + 1;
    final nextRank = _calculateRankFromLevel(nextLevel);
    final nextThreshold =
        levelThresholds[nextLevel] ?? (levelThresholds[level]! + 1000);

    return {
      'nextLevel': nextLevel,
      'nextRank': nextRank,
      'xpNeeded': nextThreshold - xp,
      'currentLevelMinXP': levelThresholds[level] ?? 0,
      'nextLevelMinXP': nextThreshold,
    };
  }

  /// 🔥 NEW: Get badge counts by category
  Map<String, int> get badgeCategoryCounts {
    Map<String, int> counts = {
      'Level': 0,
      'Category': 0,
      'Milestone': 0,
      'Seasonal': 0,
      'Special': 0,
    };

    for (var badge in badges) {
      if (badge.contains('Level')) {
        counts['Level'] = counts['Level']! + 1;
      } else if (badge.contains('Toy') ||
          badge.contains('Education') ||
          badge.contains('Food') ||
          badge.contains('Clothes') ||
          badge.contains('Money')) {
        counts['Category'] = counts['Category']! + 1;
      } else if (badge.contains('Christmas') ||
          badge.contains('Ramadan') ||
          badge.contains('Independence')) {
        counts['Seasonal'] = counts['Seasonal']! + 1;
      } else if (badge.contains('First') ||
          badge.contains('Welcome') ||
          badge.contains('Weekly') ||
          badge.contains('Dedicated') ||
          badge.contains('Collector')) {
        counts['Milestone'] = counts['Milestone']! + 1;
      } else {
        counts['Special'] = counts['Special']! + 1;
      }
    }

    return counts;
  }

  /// 🔥 NEW: Get total donation statistics
  Map<String, dynamic> get donationStats {
    double totalAmount = userDonations.fold(
      0.0,
      (sum, d) => sum + (d.amount ?? 0),
    );
    int totalItems = userDonations.fold(0, (sum, d) => sum + (d.quantity ?? 0));
    int uniqueOrphanages = userDonations
        .map((d) => d.foundationId)
        .toSet()
        .length;

    return {
      'totalAmount': totalAmount,
      'totalItems': totalItems,
      'donationCount': userDonations.length,
      'uniqueOrphanages': uniqueOrphanages,
      'avgDonationAmount': userDonations.isNotEmpty
          ? totalAmount / userDonations.length
          : 0,
      'firstDonationDate': userDonations.isNotEmpty
          ? userDonations.last.timestamp
          : null,
      'lastDonationDate': userDonations.isNotEmpty
          ? userDonations.first.timestamp
          : null,
    };
  }

  /// 🔥 NEW: Helper method to add badge
  void _addBadge(String badge) {
    if (!badges.contains(badge)) {
      badges.add(badge);
    }
  }
}

import 'dart:async';
import 'package:donate/VIEW/login/signin_view.dart';
import 'package:donate/VIEW/SCREENS/DONOR/donor_tabbar_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_adminForm_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_rejection_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
import 'package:donate/VIEWMODEL/auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Zego Cloud configuration constants
  static const zegoAppId = 1253586825;
  static const zegoAppSign =
      "08be57d145c3855da96f0643f13ad0aa8ead83ad7fb51a51c18eb1777bfa54b6";

  // Store current Zego user ID locally to track changes
  String _currentZegoUserId = "";

  @override
  void initState() {
    super.initState();

    // Initialize and check login status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndCheckLogin();
    });
  }

  Future<void> _initializeAndCheckLogin() async {
    try {
      // First, get local user data directly using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (isLoggedIn) {
        final userId = prefs.getString('user_id') ?? "";
        final userName = prefs.getString('user_name') ?? "User";

        if (userId.isNotEmpty) {
          // Initialize Zego with local user data
          await _initializeZegoCloud(userId, userName);
          _currentZegoUserId = userId;
          print("✅ Zego initialized with LOCAL user: $userName ($userId)");
        } else {
          // Use temp user
          await _initializeZegoCloud("temp_user_123", "Guest User");
          _currentZegoUserId = "temp_user_123";
          print("✅ Zego initialized with TEMP user");
        }
      } else {
        // Not logged in, use temporary user
        await _initializeZegoCloud("temp_user_123", "Guest User");
        _currentZegoUserId = "temp_user_123";
        print("✅ Zego initialized with TEMP user");
      }
    } catch (e) {
      print("❌ Error initializing Zego: $e");
      // Fallback to temporary user
      await _initializeZegoCloud("temp_user_123", "Guest User");
      _currentZegoUserId = "temp_user_123";
    }

    // Now check login status using AuthViewModel
    _checkLoginStatus();
  }

  // Initialize Zego Cloud
  Future<void> _initializeZegoCloud(String userId, String userName) async {
    print("🔄 Initializing dsdsdsdsds Cloud for user: $userName ($userId)");
    try {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: zegoAppId,
        appSign: zegoAppSign,
        userID: userId,
        userName: "user_assan",
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    } catch (e) {
      print("❌ Error initializing Zego Cloud: $e");
      rethrow;
    }
  }

  Future<void> _checkLoginStatus() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Check if user is logged in via local storage
    final isLoggedIn = await authViewModel.checkAutoLogin();

    if (!isLoggedIn) {
      // User not logged in, go to SignIn
      _navigateToSignIn();
      return;
    }

    // User is logged in, get user data
    final userInfo = await authViewModel.getCurrentUserInfo();

    if (userInfo['error'] != null) {
      // Error getting user info, go to SignIn
      _navigateToSignIn();
      return;
    }

    // Check if Zego needs to be updated with new user data
    final userId = userInfo['userId'] as String;
    final userName = userInfo['userName'] as String;

    if (userId.isNotEmpty &&
        userName.isNotEmpty &&
        _currentZegoUserId != userId) {
      // Update Zego with actual user data
      await _initializeZegoCloud(userId, userName);
      _currentZegoUserId = userId;
      print("✅ Zego updated with user: $userName ($userId)");
    }

    // Navigate based on user type
    _navigateBasedOnUserType(userInfo);
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreenView()),
    );
  }

  void _navigateBasedOnUserType(Map<String, dynamic> userInfo) {
    final userType = userInfo['userType'];
    final userId = userInfo['userId'];
    final userName = userInfo['userName'];
    final userEmail = userInfo['userEmail'];
    final userPhone = userInfo['userPhone'];

    Widget destination;

    if (userType == 'donor') {
      destination = DonorTabBarView(
        username: userName,
        useremail: userEmail,
        userphone: userPhone,
        uid: userId,
      );
    } else if (userType == 'orphanage') {
      final status = userInfo['orphanageStatus'];

      if (status == "accepted") {
        destination = const OrphanageDashboardView();
      } else if (status == "OrphanageFormPending") {
        destination = const OrphanageSignupView();
      } else if (status == "Rejected") {
        destination = const OrphanageRejectionView();
      } else if (status == "AdminApprovalWaiting") {
        destination = OrphanagWaitingView();
      } else {
        // Default fallback
        destination = const OrphanageSignupView();
      }
    } else {
      // Unknown user type, go to SignIn
      destination = SignInScreenView();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Hero(
                tag: 'app-logo',
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade100,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // App Name
              Text(
                'DONATE APP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              // Tagline
              Text(
                'Connecting Hearts, Changing Lives',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 50),

              // Loading indicator
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Loading text
              Text(
                'Initializing app...',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 5),

              Text(
                'Zego Cloud: Initializing',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 40),

              // Footer text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Making a difference, one donation at a time',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

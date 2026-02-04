import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/ADMIN/admin_dashboard.dart';
import 'package:donate/VIEW/SCREENS/DONOR/donor_tabbar_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_adminForm_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_rejection_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
import 'package:donate/VIEW/login/signin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers for Signup
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Controllers for SignIn (reuse emailController & passwordController)
  // If you prefer separate controllers, uncomment these
  // final signInEmailController = TextEditingController();
  // final signInPasswordController = TextEditingController();

  // Dropdown: user type
  String? _userType; // "donor" or "orphanage"
  String? get userType => _userType;

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }

  // Password visibility (for both signup & signin)
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    // signInEmailController.dispose();
    // signInPasswordController.dispose();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // ================= LOCAL STORAGE METHODS =================
  // Initialize SharedPreferences
  Future<void> _initLocalStorage() async {
    _prefs = await SharedPreferences.getInstance();
  }

  late SharedPreferences _prefs;

  // Keys for local storage
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _orphanageStatusKey = 'orphanage_status';

  // Save user data to local storage after signup
  Future<void> _saveUserDataLocally({
    required String userId,
    required String userType,
    required String userName,
    required String userEmail,
    required String userPhone,
    String? orphanageStatus,
  }) async {
    await _initLocalStorage();
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userTypeKey, userType);
    await _prefs.setString(_userNameKey, userName);
    await _prefs.setString(_userEmailKey, userEmail);
    await _prefs.setString(_userPhoneKey, userPhone);
    await _prefs.setBool(_isLoggedInKey, true);

    if (orphanageStatus != null) {
      await _prefs.setString(_orphanageStatusKey, orphanageStatus);
    }
  }

  // Save user data to local storage after login
  Future<void> _saveLoginDataLocally({
    required String userId,
    required String userType,
    required String userName,
    required String userEmail,
    required String userPhone,
    String? orphanageStatus,
  }) async {
    await _initLocalStorage();
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userTypeKey, userType);
    await _prefs.setString(_userNameKey, userName);
    await _prefs.setString(_userEmailKey, userEmail);
    await _prefs.setString(_userPhoneKey, userPhone);
    await _prefs.setBool(_isLoggedInKey, true);

    if (orphanageStatus != null) {
      await _prefs.setString(_orphanageStatusKey, orphanageStatus);
    }
  }

  // Get local user data
  Future<Map<String, dynamic>> getLocalUserData() async {
    await _initLocalStorage();
    return {
      'userId': _prefs.getString(_userIdKey) ?? '',
      'userType': _prefs.getString(_userTypeKey) ?? '',
      'userName': _prefs.getString(_userNameKey) ?? '',
      'userEmail': _prefs.getString(_userEmailKey) ?? '',
      'userPhone': _prefs.getString(_userPhoneKey) ?? '',
      'orphanageStatus': _prefs.getString(_orphanageStatusKey) ?? '',
      'isLoggedIn': _prefs.getBool(_isLoggedInKey) ?? false,
    };
  }

  // Check if user is logged in locally
  Future<bool> checkAutoLogin() async {
    await _initLocalStorage();
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear local data on logout
  Future<void> clearLocalData() async {
    await _initLocalStorage();
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userTypeKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userPhoneKey);
    await _prefs.remove(_orphanageStatusKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }

  // Update orphanage status locally
  Future<void> updateOrphanageStatusLocally(String status) async {
    await _initLocalStorage();
    await _prefs.setString(_orphanageStatusKey, status);
  }

  // Clear form data
  void _clearFormData() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    _userType = null;
    notifyListeners();
  }

  // ================= SIGNUP FUNCTION =================
  Future<void> signUp(BuildContext context) async {
    if (!validateForm()) return;

    if (_userType == null || _userType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select account type')),
      );
      return;
    }

    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text.trim();

    try {
      // 1️⃣ Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception('User ID is null');

      // 2️⃣ Create document in Firestore based on userType
      final collectionName = _userType == 'donor' ? 'donor' : 'orphanage';

      Map<String, dynamic> userData = {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'userType': _userType,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // 🔹 If orphanage, add status as string
      if (_userType == 'orphanage') {
        userData['status'] = "OrphanageFormPending";
        // userData['adminApprove'] = null;
      }

      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .set(userData);

      // 3️⃣ Save data locally
      await _saveUserDataLocally(
        userId: uid,
        userType: _userType!,
        userName: fullName,
        userEmail: email,
        userPhone: phone,
        orphanageStatus: _userType == 'orphanage'
            ? "OrphanageFormPending"
            : null,
      );

      // 4️⃣ Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // Clear form data
      _clearFormData();

      Nav.push(context, SignInScreenView());
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == 'email-already-in-use') message = 'Email already in use';
      if (e.code == 'weak-password') message = 'Password is too weak';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ================= SIGNIN FUNCTION =================
  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // 🔴 ADMIN CHECK FIRST
    if (email == "admin6677@gmail.com") {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Clear any previous user data from local storage
        await clearLocalData();

        Nav.push(context, const AdminOrphanagePage());
      } on FirebaseAuthException catch (e) {
        String message = 'Something went wrong';
        if (e.code == 'user-not-found') message = 'No admin found';
        if (e.code == 'wrong-password') message = 'Incorrect password';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
      return; // skip other validation
    }

    // ✅ For Donor / Orphanage
    if (!validateForm()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception('User ID is null');

      // Donor check
      final donorDoc = await FirebaseFirestore.instance
          .collection('donor')
          .doc(uid)
          .get();
      if (donorDoc.exists) {
        final donorData = donorDoc.data();
        final donorname = donorData?['fullName'];
        final donoremail = donorData?['email'];
        final donorphone = donorData?['phone'];

        // Save donor data locally
        await _saveLoginDataLocally(
          userId: uid,
          userType: 'donor',
          userName: donorname ?? "null",
          userEmail: donoremail ?? "null",
          userPhone: donorphone ?? "null",
        );

        Nav.push(
          context,
          DonorTabBarView(
            username: donorname ?? "null",
            useremail: donoremail ?? "null",
            userphone: donorphone ?? "null",
            uid: uid,
          ),
        );
        return;
      }

      // Orphanage check
      final orphanageDoc = await FirebaseFirestore.instance
          .collection('orphanage')
          .doc(uid)
          .get();

      if (orphanageDoc.exists) {
        final data = orphanageDoc.data();
        // final bool? adminApprove = data?['adminApprove'];

        final String status = data?['status'] ?? "false";
        final orphanageName = data?['fullName'] ?? "null";
        final orphanageEmail = data?['email'] ?? "null";
        final orphanagePhone = data?['phone'] ?? "null";

        // Save orphanage data locally
        await _saveLoginDataLocally(
          userId: uid,
          userType: 'orphanage',
          userName: orphanageName,
          userEmail: orphanageEmail,
          userPhone: orphanagePhone,
          orphanageStatus: status,
        );

        if (status == "OrphanageFormPending") {
          Nav.push(context, const OrphanageSignupView());
        } else if (status == "accepted") {
          Nav.push(context, const OrphanageDashboardView());
        } else if (status == "Rejected") {
          // ⏳ Not submitted / incomplete
          Nav.push(context, const OrphanageRejectionView());
        } else if (status == "AdminApprovalWaiting") {
          // ⏳ Waiting for verification
          Nav.push(context, OrphanagWaitingView());
        }

        return;
      }

      throw Exception('User role not found');
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == 'user-not-found') message = 'No user found for this email';
      if (e.code == 'wrong-password') message = 'Incorrect password';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ================= LOGOUT FUNCTION =================
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await clearLocalData();

      // Navigate to login screen and remove all previous routes
      Nav.push(context, SignInScreenView());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: ${e.toString()}')));
    }
  }

  // ================= GET CURRENT USER INFO =================
  Future<Map<String, dynamic>> getCurrentUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'error': 'No user logged in'};
      }

      // Try to get data from local storage first
      final localData = await getLocalUserData();
      if (localData['isLoggedIn'] == true && localData['userId'].isNotEmpty) {
        return localData;
      }

      // If not in local storage, fetch from Firebase
      final uid = user.uid;

      // Check donor collection
      final donorDoc = await FirebaseFirestore.instance
          .collection('donor')
          .doc(uid)
          .get();

      if (donorDoc.exists) {
        final data = donorDoc.data();
        return {
          'userId': uid,
          'userType': 'donor',
          'userName': data?['fullName'] ?? '',
          'userEmail': data?['email'] ?? '',
          'userPhone': data?['phone'] ?? '',
          'isLoggedIn': true,
        };
      }

      // Check orphanage collection
      final orphanageDoc = await FirebaseFirestore.instance
          .collection('orphanage')
          .doc(uid)
          .get();

      if (orphanageDoc.exists) {
        final data = orphanageDoc.data();
        return {
          'userId': uid,
          'userType': 'orphanage',
          'userName': data?['fullName'] ?? '',
          'userEmail': data?['email'] ?? '',
          'userPhone': data?['phone'] ?? '',
          'orphanageStatus': data?['status'] ?? '',
          'isLoggedIn': true,
        };
      }

      return {'error': 'User data not found'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

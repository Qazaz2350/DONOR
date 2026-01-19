import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/DONOR/donor_tabbar_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_Form_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
import 'package:donate/VIEW/login/signin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

      await FirebaseFirestore.instance.collection(collectionName).doc(uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'userType': _userType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3️⃣ Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      Nav.push(context, SignInScreenView());
      // TODO: Navigate to SignIn or Home
      // Nav.push(context, SignInScreenView());
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      }

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
    if (!validateForm()) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception('User ID is null');

      // Detect user type
      String? userType;
      final donorDoc = await FirebaseFirestore.instance
          .collection('donor')
          .doc(uid)
          .get();
      if (donorDoc.exists) {
        userType = 'donor';
      } else {
        final orphanageDoc = await FirebaseFirestore.instance
            .collection('orphanage')
            .doc(uid)
            .get();
        if (orphanageDoc.exists) {
          userType = 'orphanage';
        }
      }

      if (userType == null) throw Exception('User type not found');

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in successfully as $userType')),
      );

      // Navigate based on detected type
      if (userType == 'donor') {
        Nav.push(context, const DonorTabBarView());
      } else if (userType == 'orphanage') {
        Nav.push(context, OrphanageDashboardView());
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == 'user-not-found') {
        message = 'No user found for this email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

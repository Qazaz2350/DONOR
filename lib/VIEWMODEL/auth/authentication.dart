import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/ADMIN/admin_dashboard.dart';
import 'package:donate/VIEW/SCREENS/DONOR/donor_tabbar_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_Form_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_rejection_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
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

      // 3️⃣ Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

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
        Nav.push(context, const DonorTabBarView());
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
}

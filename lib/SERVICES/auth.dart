// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:donate/MODELS/auth/signup_model.dart';
// import 'package:flutter/material.dart';

// class SignUpViewModel extends ChangeNotifier {
//   final formKey = GlobalKey<FormState>();

//   // Controllers
//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   // Dropdown: user type
//   String? _userType; // "donor" or "orphanage"
//   String? get userType => _userType;

//   void setUserType(String type) {
//     _userType = type;
//     notifyListeners();
//   }

//   // Password visibility
//   bool _isPasswordVisible = false;
//   bool get isPasswordVisible => _isPasswordVisible;

//   void togglePasswordVisibility() {
//     _isPasswordVisible = !_isPasswordVisible;
//     notifyListeners();
//   }

//   void disposeControllers() {
//     fullNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   bool validateForm() {
//     return formKey.currentState?.validate() ?? false;
//   }

//   Future<void> signUp(BuildContext context) async {
//     if (!validateForm()) return;

//     if (_userType == null || _userType!.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select account type')),
//       );
//       return;
//     }

//     final fullName = fullNameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text;

//     try {
//       // Show loading SnackBar
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Creating account...')));

//       // Create user in Firebase Auth
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       String uid = userCredential.user!.uid;

//       // Create user model
//       final user = SignUpModel(
//         fullName: fullName,
//         email: email,
//         password: password,
//         userType: _userType!,
//       );

//       // Determine collection based on userType
//       String collection = _userType == 'donor' ? 'donors' : 'orphanages';

//       // Save user data in Firestore
//       await FirebaseFirestore.instance.collection(collection).doc(uid).set({
//         'uid': uid,
//         'fullName': user.fullName,
//         'email': user.email,
//         'userType': user.userType,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );

//       print(
//         "User signed up: ${user.fullName}, ${user.email}, Type: ${user.userType}, UID: $uid",
//       );

//       // You can navigate to Home or next screen here
//       // Nav.pushReplacement(context, HomeScreen());
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
//       print("FirebaseAuthException: $e");
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//       print("Error: $e");
//     }
//   }
// }

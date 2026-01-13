import 'package:donate/MODELS/auth/signup_model.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void signUp(BuildContext context) {
    if (!validateForm()) return;

    // Example: Show SnackBar (replace with your actual signup logic)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signing up...')));

    // Here you can create the model instance or call API
    final user = SignUpModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    print("User signed up: ${user.fullName}, ${user.email}");
  }
}

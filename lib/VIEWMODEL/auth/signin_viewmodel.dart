import 'package:flutter/material.dart';

class SignInViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void signIn(BuildContext context) {
    if (!validateForm()) return;

    // TODO: Replace with actual sign-in logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signing in...')));
    print(
      'Email: ${emailController.text}, Password: ${passwordController.text}',
    );
  }
}

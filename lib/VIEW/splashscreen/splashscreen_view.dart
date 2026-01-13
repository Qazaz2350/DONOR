import 'dart:async';
import 'package:donate/VIEW/Onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';

class SplashscreenView extends StatefulWidget {
  const SplashscreenView({super.key});

  @override
  State<SplashscreenView> createState() => _SplashscreenViewState();
}

class _SplashscreenViewState extends State<SplashscreenView> {
  @override
  void initState() {
    super.initState();

    // ⏳ 2 seconds delay
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
    });
  }

  @override   
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/logo.png", height: 150),
            const SizedBox(height: 10),
            Text(
              "D O N A T E",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

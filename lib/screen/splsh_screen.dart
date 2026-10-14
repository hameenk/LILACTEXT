import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppTheme.teal,
    body: Center(
      child: Text(
        'Expenzia',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w600,
          letterSpacing: .3,
        ),
      ),
    ),
  );
}

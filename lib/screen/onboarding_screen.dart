import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/screen/homepage.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        // Image fills the top area (it has its own background and slant)
        Expanded(
          flex: 7,
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              'asset/image/image.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance_wallet_rounded,
                size: 120,
                color: AppTheme.teal,
              ),
            ),
          ),
        ),

        // Bottom text + button
        Expanded(
          flex: 3,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Spend Smarter\nSave More',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.teal,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.teal.withAlpha(90),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.teal,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// src/login/_verify_signup.dart
import "package:flutter/material.dart";
import 'package:pcic_mobile_app/utils/app/_colors.dart';

import '_login.dart';

class VerifySignupPage extends StatelessWidget {
  final bool isSignupSuccessful;

  const VerifySignupPage({super.key, required this.isSignupSuccessful});

  @override
  Widget build(BuildContext context) {
    if (isSignupSuccessful) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSignupSuccessful ? Icons.check : Icons.error,
              size: 100,
              color: isSignupSuccessful ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: 20),
            Text(
              isSignupSuccessful
                  ? "Your Sign up was successful!"
                  : "Signup Failed!",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

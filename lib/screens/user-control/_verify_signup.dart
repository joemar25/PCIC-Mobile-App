import "package:flutter/material.dart";
import 'package:pcic_mobile_app/screens/dashboard/_home.dart';

class VerifySignupPage extends StatelessWidget {
  final bool isSignupSuccessful;

  const VerifySignupPage({super.key, required this.isSignupSuccessful});

  @override
  Widget build(BuildContext context) {
    if (isSignupSuccessful) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSignupSuccessful ? Icons.check_circle : Icons.error,
              size: 100,
              color: isSignupSuccessful ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isSignupSuccessful ? "Signup Successful!" : "Signup Failed!",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

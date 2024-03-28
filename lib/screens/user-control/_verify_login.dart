import "package:flutter/material.dart";
import 'package:pcic_mobile_app/screens/dashboard/_home.dart';

class VerifyLoginPage extends StatelessWidget {
  final bool isLoginSuccessful;

  const VerifyLoginPage({super.key, required this.isLoginSuccessful});

  @override
  Widget build(BuildContext context) {
    if (isLoginSuccessful) {
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
              isLoginSuccessful ? Icons.check_circle : Icons.error,
              size: 100,
              color: isLoginSuccessful ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isLoginSuccessful ? "Login Successful!" : "Login Failed!",
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

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pcic_mobile_app/src/home/dashboard.dart';
import 'package:pcic_mobile_app/utils/app/_colors.dart';

class FormSuccessPage extends StatelessWidget {
  final bool isSaveSuccessful;

  const FormSuccessPage({super.key, required this.isSaveSuccessful});

  @override
  Widget build(BuildContext context) {
    if (isSaveSuccessful) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "Successful",
              style: TextStyle(
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

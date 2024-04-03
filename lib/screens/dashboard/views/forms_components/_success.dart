import "package:flutter/material.dart";
import 'package:pcic_mobile_app/screens/dashboard/_home.dart';
import 'package:pcic_mobile_app/utils/_app_colors.dart';

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

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 100,
              color: AppColors.success,
            ),
            SizedBox(height: 20),
            Text(
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

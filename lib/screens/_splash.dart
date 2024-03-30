import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pcic_mobile_app/screens/_starting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pcic_mobile_app/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer(duration, _navigateToStartingPage);
  }

  void _navigateToStartingPage() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StartingPage()),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.primaryDark),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.63,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(250, 100),
                  bottomRight: Radius.elliptical(250, 100),
                ),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/storage/images/icon.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: SpinKitCircle(
                  color: AppColors.onPrimary,
                  size: 50.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

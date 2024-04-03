import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
// import 'package:pcic_mobile_app/utils/_app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFD2FFCB),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 4)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Lottie.asset('assets/animations/SplashFlow.json'));
          } else {
            // Navigate to the starting page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/starting');
            });
            return Container(); // Placeholder widget
          }
        },
      ),
    );
  }
}


/**
 * 
 * Stack(
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
                Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Lottie.asset("assets/animations/walk.json")),
                  ),
                ),
              ],
            );
 * 
 * 
 * 
 */
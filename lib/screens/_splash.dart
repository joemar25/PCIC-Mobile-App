import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pcic_mobile_app/utils/_app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
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
            );
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

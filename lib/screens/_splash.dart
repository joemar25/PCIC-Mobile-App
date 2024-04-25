import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/_starting.dart';
import 'package:pcic_mobile_app/screens/home/_home.dart';
import 'package:pcic_mobile_app/utils/agent/_session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkExistingToken();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 75.0, end: 140.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingToken() async {
    Session session = Session();
    String? token = await session.getToken();
    await Future.delayed(const Duration(seconds: 3));

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2FFCB),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              width: _animation.value,
              height: _animation.value,
              child: Image.asset(
                'assets/animations/loading-location.gif',
                fit: BoxFit.contain,
              ),
            );
          },
        ),
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
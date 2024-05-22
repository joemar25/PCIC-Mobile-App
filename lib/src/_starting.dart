import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/agent/_login.dart';
import 'package:pcic_mobile_app/utils/agent/_session.dart';

import 'home/_home.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  Future<void> _checkExistingToken(BuildContext context) async {
    Session session = Session();
    String? token = await session.getToken();
    // Token exists, navigate to the dashboard
    if (token != null && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkExistingToken(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while checking for the token
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // Return the main content of the page
          return Scaffold(
            backgroundColor: const Color(0xFFD2FFCB),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 100, // Adjust width as needed
                      height: 100,
                      child: Image.asset(
                        'assets/storage/images/icon.png',
                        // Adjust height as needed
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            backgroundColor: const Color(0xFF0F7D40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: const Text(
                            "Sign inxxxxxxxxxxx",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/authentication/_login.dart'; // Assuming LoginPage is imported from this path

class LogoutSuccessPage extends StatefulWidget {
  const LogoutSuccessPage({Key? key}) : super(key: key);

  @override
  _LogoutSuccessPageState createState() => _LogoutSuccessPageState();
}

class _LogoutSuccessPageState extends State<LogoutSuccessPage> {
  late StreamSubscription<User?> _authStateChangesSubscription;

  @override
  void initState() {
    super.initState();
    // Subscribe to authentication state changes
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is logged out, you can handle this event here
        debugPrint('User logged out');
        // Navigate to the login screen or perform any other action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Don't forget to cancel the subscription when the widget is disposed
    _authStateChangesSubscription.cancel();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('Logout successful');
    } catch (e) {
      print('Error logging out: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Logout Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _logout(context);
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

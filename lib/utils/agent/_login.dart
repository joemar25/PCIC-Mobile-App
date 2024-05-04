import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pcic_mobile_app/utils/agent/_session.dart';
import 'package:pcic_mobile_app/utils/agent/_signup.dart';
import 'package:pcic_mobile_app/utils/agent/_verify_login.dart';
import 'package:pcic_mobile_app/utils/agent/login-components/_login_remember_and_forgot.dart';
import 'package:pcic_mobile_app/utils/agent/login-components/_login_text_field.dart';

import '../../src/home/_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String parentEmail = '';
  String parentPassword = '';
  bool _isLoading = false;

  final Session _session = Session();

  @override
  void initState() {
    super.initState();
    _checkExistingToken();
  }

  Future<void> _checkExistingToken() async {
    String? token = await _session.getToken();
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      if (token != null) {
        // Token exists, navigate to the home page
        _navigateToDashboard();
      }
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  void _navigateToVerifyLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VerifyLoginPage(
          isLoginSuccessful: true,
        ),
      ),
    );
  }

  void _showLoginFailedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          style: TextStyle(
            color: Colors.red,
            fontSize: 13.3,
            fontWeight: FontWeight.w600,
          ),
          'Login failed. Please check your email and password.',
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void updateParentEmail(String value) {
    setState(() {
      parentEmail = value;
    });
  }

  void updateParentPassword(String newPassword) {
    setState(() {
      parentPassword = newPassword;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (mounted && status.isGranted) {
      await _getCurrentLocation();
    } else {
      debugPrint('Location permission denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint(
          'Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 100.0),
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100, // Adjust width as needed
              height: 100,
              child: Image.asset(
                'assets/storage/images/icon.png',
                // Adjust height as needed
              ),
            ),
            const Text(
              'Sign in to your account',
              style: TextStyle(fontSize: 27.65, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFD2FFCB),
      bottomSheet: BottomSheet(
        backgroundColor: const Color(0xFFD2FFCB),
        elevation: 0.0,
        onClosing: () {},
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
            ),
            height: 500,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 70.0,
                horizontal: 40.0,
              ),
              child: Column(
                children: [
                  LoginTextField(
                    inputType: 'Email',
                    svgPath: 'assets/storage/images/mail.svg',
                    onTextChanged: updateParentEmail,
                  ),
                  const SizedBox(height: 30),
                  LoginTextField(
                    inputType: 'Password',
                    svgPath: 'assets/storage/images/lock.svg',
                    onTextChanged: updateParentPassword,
                  ),
                  const SizedBox(height: 15),
                  const RememberAndForgot(),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: parentEmail,
                                password: parentPassword,
                              );
                              // Login successful, initialize the session with the user token
                              String? token =
                                  await userCredential.user?.getIdToken();
                              _session.init(token!);
                              // Request location permission
                              await _requestLocationPermission();
                              // Navigate to the next screen
                              _navigateToVerifyLogin();

                              debugPrint('Token: $token');
                            } catch (e) {
                              // Handle login error
                              debugPrint('Login error: $e');
                              // Show an error message to the user
                              _showLoginFailedSnackBar();
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: const Color(0xFF0F7D40),
                          ),
                          child: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 13.0,
                                    horizontal: 8.0,
                                  ),
                                  child: SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 13.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                          ),
                          TextSpan(
                            text: "Sign up here",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F7D40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

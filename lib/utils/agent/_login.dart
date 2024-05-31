import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pcic_mobile_app/src/home/dashboard.dart';
import 'package:pcic_mobile_app/utils/agent/_session.dart';
import 'package:pcic_mobile_app/utils/agent/_verify_login.dart';
import 'package:pcic_mobile_app/utils/agent/login-components/_login_remember_and_forgot.dart';
import 'package:pcic_mobile_app/utils/agent/login-components/_login_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _checkExistingToken(context);
  }

  Future<void> _checkExistingToken(BuildContext context) async {
    String? token = await _session.getToken();
    if (token != null && context.mounted) {
      _navigateToDashboard();
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

  void _showLoginFailedSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 13.3,
            fontWeight: FontWeight.w600,
          ),
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

  Future<void> _requestPermissions() async {
    final locationStatus = await Permission.location.request();
    final storageStatus = await Permission.manageExternalStorage.request();

    if (mounted) {
      if (locationStatus.isGranted && storageStatus.isGranted) {
        await _getCurrentLocation();
      } else {
        if (!locationStatus.isGranted) {
          _showLoginFailedSnackBar('Location permission denied');
        }
        if (!storageStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'External storage permission is required to open GPX files'),
            ),
          );
        }
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get current location'),
          ),
        );
      }
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: parentEmail,
        password: parentPassword,
      );
      // Login successful, initialize the session with the user token
      String? token = await userCredential.user?.getIdToken();
      _session.init(token!);
      // Request location permission
      await _requestPermissions();
      // Navigate to the next screen
      _navigateToVerifyLogin();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
          break;
      }
      _showLoginFailedSnackBar(errorMessage);
    } catch (e) {
      _showLoginFailedSnackBar(
          'An unexpected error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.13,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                "assets/storage/images/icon.png",
                height: MediaQuery.of(context).size.height * 0.14,
                fit: BoxFit.cover,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              const Text(
                'Sign in to your account',
                style: TextStyle(fontSize: 27.65, fontWeight: FontWeight.w600),
              ),
            ],
          ),
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
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 70.0,
                horizontal: 40.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LoginTextField(
                      inputType: 'Email',
                      svgPath: 'assets/storage/images/mail.svg',
                      onTextChanged: updateParentEmail,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: const Color(0xFF0F7D40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 13.0,
                                horizontal: 8.0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 23.0,
                                      width: 23.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 4,
                                      ),
                                    )
                                  : const Text(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

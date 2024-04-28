import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_home.dart';
import 'package:pcic_mobile_app/utils/agent/_session.dart';
import 'package:pcic_mobile_app/utils/agent/_signup.dart';
import 'package:pcic_mobile_app/utils/agent/_verify_login.dart';
import 'package:pcic_mobile_app/utils/agent/logincomponents/_login_remember_and_forgot.dart';
import 'package:pcic_mobile_app/utils/agent/logincomponents/_login_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String parentEmail = '';
  String parentPassword = '';

  final Session _session = Session();

  @override
  void initState() {
    super.initState();
    _checkExistingToken();
  }

  Future<void> _checkExistingToken() async {
    String? token = await _session.getToken();
    if (token != null) {
      // Token exists, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
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
              style: TextStyle(fontSize: 27.65, fontWeight: FontWeight.w500),
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
                      topRight: Radius.circular(50.0))),
              height: 500,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 70.0, horizontal: 40.0),
                child: Column(
                  children: [
                    LoginTextField(
                      inputType: 'Email',
                      svgPath: 'assets/storage/images/mail.svg',
                      onTextChanged: updateParentEmail,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    LoginTextField(
                      inputType: 'Password',
                      svgPath: 'assets/storage/images/lock.svg',
                      onTextChanged: updateParentPassword,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const RememberAndForgot(),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                    email: parentEmail,
                                    password: parentPassword,
                                  );
                                  // Login successful, initialize the session with the user token
                                  String? token =
                                      await userCredential.user?.getIdToken();
                                  _session.init(token!);
                                  // Login successful, navigate to the next screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VerifyLoginPage(
                                        isLoginSuccessful: true,
                                      ),
                                    ),
                                  );

                                  debugPrint('Token: $token');
                                } catch (e) {
                                  // Handle login error
                                  debugPrint('Login error: $e');
                                  // Show an error message to the user
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Login failed. Please check your email and password.'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                backgroundColor: const Color(0xFF0F7D40),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 8.0),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
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
              ));
        },
      ),
    );
  }
}

/** 
 * 
 * 
 * shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                topRight: Radius.circular(45.0))),
 * 
 * 
 * 
 * Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF89C53F),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 5, top: 4),
                child: ClipOval(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/storage/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email,
                      password: _password,
                    );
                    // Login successful, initialize the session with the user token
                    String? token = await userCredential.user?.getIdToken();
                    _session.init(token!);
                    // Login successful, navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VerifyLoginPage(
                          isLoginSuccessful: true,
                        ),
                      ),
                    );

                    debugPrint('Token: $token');
                  } catch (e) {
                    // Handle login error
                    debugPrint('Login error: $e');
                    // Show an error message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Login failed. Please check your email and password.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: const Color(0xFF0C7D3F),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        color: Color(0xFF89C53F),
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
 * 
 * 
 * 
 * 
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_home.dart';
import 'package:pcic_mobile_app/utils/agent/_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    vertical: 30.0, horizontal: 40.0),
                child: Column(
                  children: [
                    Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.mail,
                            color: Colors.grey,
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 1.0,
                            indent: 8.0,
                            endIndent: 8.0,
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 27.65,
                                    child: TextField(
                                      style: const TextStyle(
                                          color: Color(0xFF000E08),
                                          fontSize: 19.2,
                                          fontWeight: FontWeight
                                              .w500 // Adjust font size as needed (smaller values for smaller font)
                                          ),
                                      onChanged: (value) {
                                        setState(() {
                                          _email = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Input your email...',
                                        hintStyle: TextStyle(fontSize: 19.2),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide
                                              .none, // Removes the border
                                        ),
                                        contentPadding: EdgeInsets.zero,

                                        // Remove the border
                                        filled:
                                            false, // Remove the filled background color
                                      ),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
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
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value:
                                false, // Set the value to a variable to handle its state
                            onChanged: (value) {
                              // Handle the checkbox state change here
                              setState(() {
                                // Update the checkbox value when the state changes
                                // This will be used to remember the user
                                // You can store this value in a variable or persist it using SharedPreferences
                              });
                            },
                            fillColor: MaterialStateProperty.all(
                                const Color(0xFF89C53F)),
                            checkColor: Colors.white,
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle Forgot Password action
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                          ),
                        ),
                      ),
                    ],
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

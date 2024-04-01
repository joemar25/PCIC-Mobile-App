import "package:flutter/material.dart";
import "package:pcic_mobile_app/screens/user-control/_signup.dart";
import "package:pcic_mobile_app/screens/user-control/_verify_login.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'storage/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.all(20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       OutlinedButton(
            //         onPressed: () {
            //           // Handle button onPressed action
            //         },
            //         style: OutlinedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //         ),
            //         child: const Text("Login with Google",
            //         style: TextStyle(color: Color(0xFF89C53F)
            //           )
            //         ),
                    
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure children take up full width
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                          ),
                        ),
                       const SizedBox(height: 10),
                        TextField(
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
                 const SizedBox(height: 15), // Added spacing between the TextFormField and Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: null,
                            fillColor: MaterialStateProperty.all(const Color(0xFF89C53F)),
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
              width: double.infinity, // Set width to 100%
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyLoginPage(
                        isLoginSuccessful: true,
                      ),
                    ),
                  );
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
                    color: Colors.black, // Set default text color to black
                  ),
                  children: [
                    TextSpan(
                      text: "Don’t have an account? ",
                    ),
                    TextSpan(
                      text: "Sign up here",
                      style: TextStyle(
                        color: Color(0xFF89C53F), // Set text color to green
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
  }
}

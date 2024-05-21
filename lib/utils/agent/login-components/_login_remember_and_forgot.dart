import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

// Import the ForgetPasswordPage
import '../../agent/_forgetPassword.dart';

class RememberAndForgot extends StatefulWidget {
  const RememberAndForgot({super.key});

  @override
  State<RememberAndForgot> createState() => _RememberAndForgotState();
}

class _RememberAndForgotState extends State<RememberAndForgot> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                );
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decorationColor: const Color(0xFF0F7D40),
                    decoration: TextDecoration.underline,
                    color: const Color(0xFF0F7D40),
                    fontSize: t?.overline),
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class RememberAndForgot extends StatefulWidget {
  // final Function(String) onTextChanged;
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
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                      },
                      activeColor: const Color(0xFF0F7D40),
                      checkColor: Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      splashRadius: 16,
                      side: const BorderSide(width: 1.0, color: Colors.black),
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: t?.overline,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                // Handle Forgot Password action
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

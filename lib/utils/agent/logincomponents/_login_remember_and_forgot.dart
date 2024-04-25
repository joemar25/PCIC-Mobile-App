import 'package:flutter/material.dart';

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
                      activeColor: const Color(0xFF58996A),
                      checkColor: Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      splashRadius: 16,
                      side: const BorderSide(width: 1.0, color: Colors.black),
                    ),
                    const Text(
                      'Remember Me',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
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
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decorationColor: Color(0xFF58996A),
                    decoration: TextDecoration.underline,
                    color: Color(0xFF58996A),
                    fontSize: 12.0),
              ),
            ),
          ],
        ));
  }
}



/**
 * 
 * 
 * 
 * 
 * 
 */
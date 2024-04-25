import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  // final String password;
  final IconData icon; //
  final String inputType;

  final Function(String) onTextChanged;

  const LoginTextField(
      {super.key,
      required this.icon,
      required this.inputType,
      required this.onTextChanged});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  // String _email = '';
  // String _password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
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
                  Text(
                    widget.inputType,
                    style: const TextStyle(
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
                      onChanged: widget.onTextChanged,
                      obscureText:
                          widget.inputType == 'Password' ? true : false,
                      decoration: InputDecoration(
                        hintText: "Enter your ${widget.inputType}",
                        hintStyle: const TextStyle(fontSize: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none, // Removes the border
                        ),
                        contentPadding: EdgeInsets.zero,

                        // Remove the border
                        filled: false, // Remove the filled background color
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}



/**
 * 
 * if (widget.inputType == 'Email') {
                            _email = value;
                          } else if (widget.inputType == 'Password') {
                            _password = value;
                          }
 * 
 * 
 */
// themes.dart
import 'package:flutter/material.dart';

final ThemeData pcicTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        // Border color
        color: Colors.blue,
        width: 2.0, // Border width
      ),
    ),
    // enabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.pink, width: 0.5), // Default outline
    // ),
    // border: OutlineInputBorder(
    //   borderSide: BorderSide(
    //     color: Colors.black, // Default border color
    //     width: 0.5, // Default border width
    //   ),
    // ),
  ),

  cardTheme: const CardTheme(
    shape: RoundedRectangleBorder(
      side: BorderSide(
          color: Colors.green, width: 0.5), // Border for all Card widgets
    ),
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 23.04, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 19.2, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(
      fontSize: 13.3,
    ), // Default body text size
    bodySmall: TextStyle(fontSize: 11.11),
  ),
  primaryColor: const Color(0xFF0F7D40), //
);

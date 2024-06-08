import 'dart:ui';
import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  static const lightMode = CustomThemeExtension(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    display1: 22.78,
    headline: 20.25,
    title: 18.0,
    body: 16.0,
    caption: 14.22,
    overline: 11.24,
  );

  static const darkMode = CustomThemeExtension(
    backgroundColor: Colors.black,
    textColor: Colors.white,
    display1: 22.78,
    headline: 20.25,
    title: 18.0,
    body: 16.0,
    caption: 14.22,
    overline: 11.24,
  );

  final Color backgroundColor;
  final Color textColor;
  final double display1;
  final double headline;
  final double title;
  final double body;
  final double caption;
  final double overline;

  const CustomThemeExtension({
    required this.backgroundColor,
    required this.textColor,
    required this.display1,
    required this.headline,
    required this.title,
    required this.body,
    required this.caption,
    required this.overline,
  });

  @override
  CustomThemeExtension copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? display1,
    double? headline,
    double? title,
    double? body,
    double? caption,
    double? overline,
  }) {
    return CustomThemeExtension(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      display1: display1 ?? this.display1,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      display1: lerpDouble(display1, other.display1, t)!,
      headline: lerpDouble(headline, other.headline, t)!,
      title: lerpDouble(title, other.title, t)!,
      body: lerpDouble(body, other.body, t)!,
      caption: lerpDouble(caption, other.caption, t)!,
      overline: lerpDouble(overline, other.overline, t)!,
    );
  }
}

// COLORS

// green

const mainColor = Color(0xFF0F7D40);
// const mainColor = Color.fromARGB(255, 47, 184, 109);

const shadowMainColor = Color(0xFFD2FFCB);

// blue
const mainColor2 = Color(0xFF4894FE);
const shadowMainColor2 = Color(0xFFD9F7FA);

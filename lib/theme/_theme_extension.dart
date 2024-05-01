import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get pcicTheme {
    return Theme.of(this);
  }

  // TextTheme get pText => pcicTheme.textTheme;

  // Color get pColor => pcicTheme.primaryColor;
}

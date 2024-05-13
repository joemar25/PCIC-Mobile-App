import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// filename: service.dart

class SettingsService {
  static const String _themeModeKey = 'theme_mode';

  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    return ThemeMode.values[themeModeIndex ?? 0];
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, theme.index);
  }
}

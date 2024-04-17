import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String _tokenKey = 'token';
  SharedPreferences? _prefs;

  Future<void> init(String token) async {
    await _initPrefs();
    _prefs!.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    await _initPrefs();
    return _prefs!.getString(_tokenKey);
  }

  Future<void> stop() async {
    await _initPrefs();
    _prefs!.remove(_tokenKey);
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}

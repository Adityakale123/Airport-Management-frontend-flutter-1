import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../config/app_config.dart';
import '../models/user.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  // Initialize
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    await _prefs?.setString(AppConfig.tokenKey, token);
  }

  static Future<String?> getToken() async {
    return _prefs?.getString(AppConfig.tokenKey);
  }

  static Future<void> deleteToken() async {
    await _prefs?.remove(AppConfig.tokenKey);
  }

  // User Management
  static Future<void> saveUser(User user) async {
    await _prefs?.setString(AppConfig.userKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final userString = _prefs?.getString(AppConfig.userKey);
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  static Future<void> deleteUser() async {
    await _prefs?.remove(AppConfig.userKey);
  }

  // Theme Management
  static Future<void> saveThemeMode(String mode) async {
    await _prefs?.setString(AppConfig.themeKey, mode);
  }

  static Future<String?> getThemeMode() async {
    return _prefs?.getString(AppConfig.themeKey);
  }

  // Language Management
  static Future<void> saveLanguage(String language) async {
    await _prefs?.setString(AppConfig.languageKey, language);
  }

  static Future<String?> getLanguage() async {
    return _prefs?.getString(AppConfig.languageKey);
  }

  // Generic Save
  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }

  // Clear All
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

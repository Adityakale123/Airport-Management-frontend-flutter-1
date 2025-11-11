import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemeMode();
  }

  // Load saved theme mode
  Future<void> _loadThemeMode() async {
    final savedMode = await LocalStorageService.getThemeMode();
    if (savedMode != null) {
      _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await LocalStorageService.saveThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await LocalStorageService.saveThemeMode(
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }
}

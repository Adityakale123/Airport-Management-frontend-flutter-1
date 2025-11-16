class AppConfig {
  // API Configuration
  static const String baseUrl = 'http://localhost:8081/api';
  static const String apiVersion = 'v1';

  // Timeout Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // App Info
  static const String appName = 'Airport Management';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.airport.management';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableNotifications = true;
  static const bool enableOfflineMode = true;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';

  // File Limits
  static const int maxImageSizeInMB = 5;
  static const int maxPdfSizeInMB = 10;

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';
}

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // App Info
  static const String appName = 'MRentO';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Machinery, 90 min mein';

  // Rental Constants
  static const int deliveryTimeMinutes = 90;
  static const double baseDeliveryFee = 49.0;
  static const double freeDeliveryThreshold = 999.0;
  static const double defaultSecurityDeposit = 500.0;

  // URLs
  static String get socketBaseUrl =>
      dotenv.env['SOCKET_URL'] ?? 'http://localhost:5000';

  // Logging
  static bool get enableLogging => kDebugMode;
  static const bool enableConsoleLogging = true;
  static const bool enableColoredConsoleOutput = true;

  // Analytics & Crashlytics
  static bool get enableAnalytics => true; // Set to true for testing logs
  static bool get enableCrashlytics => true;

  // Log Levels
  static const String logLevelDebug = 'DEBUG';
  static const String logLevelInfo = 'INFO';
  static const String logLevelWarning = 'WARNING';
  static const String logLevelError = 'ERROR';
  static const String defaultLogLevel = logLevelDebug;

  // Log Categories
  static const String logCategoryApi = 'API';
  static const String logCategoryAuth = 'AUTH';
  static const String logCategoryUI = 'UI';
  static const String logCategoryStorage = 'STORAGE';
  static const String logCategoryNetwork = 'NETWORK';
  static const String logCategoryGeneral = 'GENERAL';
  static const String logCategoryDatabase = 'DATABASE';
  static const bool showTimestamp = true;
  static const bool showLogLevel = true;
  static const bool showSourceInfo = true;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Padding
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingLSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Button Heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  // OTP
  static const int otpLength = 6;

  // Animation
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Hardware Categories
  static const List<Map<String, String>> hardwareCategories = [
    {'id': 'power-tools', 'name': 'Power Tools', 'icon': 'drill'},
    {'id': 'construction', 'name': 'Construction', 'icon': 'construction'},
    {'id': 'lifting', 'name': 'Lifting', 'icon': 'lifting'},
    {'id': 'cleaning', 'name': 'Cleaning', 'icon': 'cleaning'},
    {'id': 'measurement', 'name': 'Measurement', 'icon': 'measurement'},
    {'id': 'gardening', 'name': 'Gardening', 'icon': 'gardening'},
  ];
}
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import 'logger_service.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static SharedPreferences? _prefs;
  final LoggingService _logger = LoggingService.instance;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserList = 'user_list';
  static const String _keyUserListTimestamp = 'user_list_timestamp';
  static const String _keyUserRole = 'user_role';
  static const String _keySeenOnboarding = 'seen_onboarding';

  // Notification caching keys
  static const String keyNotifications = 'notifications_list';

  /// Initialize storage once on app start
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    LoggingService.instance.logStorage('LocalStorageService initialized');
  }

  /// Safe getter
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'LocalStorageService not initialized. Call LocalStorageService.init() first.',
      );
    }
    return _prefs!;
  }

  /// Save string data
  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
    _logger.logStorage('Saved string: $key');
  }

  Future<String?> getString(String key) async {
    final value = prefs.getString(key);
    _logger.logStorage('Retrieved string: $key');
    return value;
  }

  Future<void> removeString(String key) async {
    await prefs.remove(key);
    _logger.logStorage('Removed string: $key');
  }

  Future<void> saveJson(String key, dynamic data) async {
    await prefs.setString(key, jsonEncode(data));
    await prefs.setInt(
      '${key}_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
    _logger.logStorage('Saved JSON cache: $key');
  }

  Future<dynamic> getJson(String key) async {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    _logger.logStorage('Loaded JSON cache: $key');
    return jsonDecode(jsonString);
  }

  Future<DateTime?> getTimestamp(String key) async {
    final ts = prefs.getInt('${key}_timestamp');
    return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  /// Boolean
  Future<void> setBool(String key, bool value) async {
    await prefs.setBool(key, value);
    _logger.logStorage('Saved bool: $key = $value');
  }

  Future<bool> getBool(String key) async {
    final value = prefs.getBool(key) ?? false;
    _logger.logStorage('Retrieved bool: $key = $value');
    return value;
  }

  /// Clear all local data
  Future<void> clearAll() async {
    await prefs.clear();
    _logger.logStorage('All local data cleared');
  }

  /// Helper for login state
  Future<void> setLoginState(bool loggedIn) async {
    await setBool(_keyIsLoggedIn, loggedIn);
  }

  Future<bool> isLoggedIn() async {
    return getBool(_keyIsLoggedIn);
  }

  /// User list methods
  Future<void> saveUserList(List<UserModel> users) async {
    final userJsonList = users.map((e) => e.toJson()).toList();
    await prefs.setString(_keyUserList, jsonEncode(userJsonList));
    await prefs.setInt(
      _keyUserListTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
    _logger.logStorage('Saved user list (${users.length} users)');
  }

  Future<List<UserModel>?> getUserList() async {
    final jsonString = prefs.getString(_keyUserList);
    if (jsonString == null) return null;

    try {
      final List<dynamic> userJsonList = jsonDecode(jsonString);
      final users = userJsonList
          .map((json) => UserModel.fromJson(json))
          .toList();
      _logger.logStorage('Retrieved user list (${users.length} users)');
      return users;
    } catch (e) {
      _logger.error('LOCAL_STORAGE', 'Failed to parse user list', error: e);
      return null;
    }
  }

  Future<DateTime?> getUserListTimestamp() async {
    final timestamp = prefs.getInt(_keyUserListTimestamp);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> clearUserList() async {
    await prefs.remove(_keyUserList);
    await prefs.remove(_keyUserListTimestamp);
    _logger.logStorage('Cleared user list cache');
  }

  Future<void> saveUserRole(String role) async {
    await prefs.setString(_keyUserRole, role);
    _logger.logStorage('Saved user role: $role');
  }

  Future<String?> getUserRole() async {
    return prefs.getString(_keyUserRole);
  }

  /// Get logged-in user name
  Future<String?> getUserName() async {
    return prefs.getString(_keyUserName);
  }

  /// Save logged-in user details
  Future<void> saveLoggedInUser({
    required String userId,
    required String userName,
  }) async {
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, userName);
    _logger.logStorage('Saved logged-in user: $userId - $userName');
  }

  /// Get logged-in user ID
  Future<String?> getUserId() async {
    return prefs.getString(_keyUserId);
  }

  Future<void> clearLoggedInUser() async {
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
  }

  // --------------------------------------------------------------------------
  // Notifications caching methods
  // --------------------------------------------------------------------------

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final jsonList = notifications.map((e) => e.toJson()).toList();
    await prefs.setString(keyNotifications, jsonEncode(jsonList));
    _logger.logStorage('Saved ${notifications.length} notifications to cache');
  }

  Future<List<NotificationModel>?> getNotifications() async {
    final jsonString = prefs.getString(keyNotifications);
    if (jsonString == null) return null;
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      _logger.error('LOCAL_STORAGE', 'Failed to parse cached notifications', error: e);
      return null;
    }
  }

  Future<void> clearNotificationsCache() async {
    await prefs.remove(keyNotifications);
    _logger.logStorage('Cleared notifications cache');
  }

  // --------------------------------------------------------------------------
  // Onboarding methods
  // --------------------------------------------------------------------------

  Future<void> setSeenOnboarding(bool seen) async {
    await setBool(_keySeenOnboarding, seen);
  }

  Future<bool> hasSeenOnboarding() async {
    return getBool(_keySeenOnboarding);
  }
}
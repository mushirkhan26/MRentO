import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../config/navigation/app_router.dart';
import '../../config/navigation/app_routes.dart';
import 'logger_service.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final LoggingService _logger = LoggingService.instance;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Initialize notification plugin
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          _logger.logNetwork("[NotificationService] Notification tapped: ${response.payload}");
          try {
            final data = jsonDecode(response.payload!);
            final orderId = data['orderId']?.toString() ?? '';
            rootNavigatorKey.currentState!.context.push(
              AppRoutes.trackOrderRoute,
              extra: orderId,
            );
          } catch (e) {
            _logger.logNetwork("[NotificationService] Failed to navigate on tap: $e");
          }
        }
      },
    );

    _logger.logNetwork("[NotificationService] Local Notification Service initialized");
    await _requestPermissions();
  }

  /// Requests notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      try {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          _logger.logNetwork("[NotificationService] Android permission result: $result");
        }
      } catch (e) {
        _logger.logNetwork("[NotificationService] Error requesting Android permission: $e");
      }
    } else if (Platform.isIOS) {
      await requestIOSPermissions();
    }
  }

  /// Explicit iOS permission request
  Future<void> requestIOSPermissions() async {
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
      _logger.logNetwork("[NotificationService] iOS notification permission requested");
    }
  }

  /// Show order status notification
  Future<void> showOrderNotification({
    required String orderId,
    required String title,
    required String body,
  }) async {
    try {
      final payload = jsonEncode({
        'orderId': orderId,
        'type': 'order_update',
      });

      final androidDetails = AndroidNotificationDetails(
        'order_channel',
        'Order Notifications',
        channelDescription: 'Shows order status updates',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: false,
        styleInformation: BigTextStyleInformation(body),
        icon: '@mipmap/ic_launcher',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      );

      await _plugin.show(1001, title, body, notificationDetails, payload: payload);
      _logger.logNetwork("[NotificationService] Order notification shown: $title");
    } catch (e) {
      _logger.logNetwork("[NotificationService] Failed to show order notification: $e");
    }
  }

  /// Clear all notifications
  Future<void> clearNotifications() async {
    await _plugin.cancelAll();
    _logger.logNetwork("[NotificationService] All notifications cleared");
  }
}
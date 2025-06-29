import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/services/alarm_permission_service.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static String? _pendingPayload; // Store payload when app is killed

  bool get isInitialized => _isInitialized;

  void initTimeZone() async {
    tz.initializeTimeZones();
    String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    if (currentTimeZone == 'Asia/Saigon') {
      currentTimeZone = 'Asia/Ho_Chi_Minh';
    }
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  // INITIALIZE
  Future<void> initialize() async {
    if (_isInitialized) return;
    await requestNotificationPermission();
    initTimeZone();

    // prepare android init settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // prepare ios init settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // combine settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;

    // Check if app was launched from notification (when app was killed)
    await _checkLaunchDetails();
  }

  // Check if the app was launched from a notification
  Future<void> _checkLaunchDetails() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final String? payload =
          notificationAppLaunchDetails?.notificationResponse?.payload;
      debugPrint('App launched from notification with payload: $payload');

      if (payload != null) {
        // Store the payload to handle after the app is fully initialized
        _pendingPayload = payload;
        // Handle the navigation after a short delay to ensure the app is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleNotificationPayload(payload);
        });
      }
    }
  }

  // Handle notification tap (both foreground and background)
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped with payload: ${response.payload}');
    if (response.payload != null) {
      _handleNotificationPayload(response.payload!);
    }
  }

  // Handle the notification payload and navigate accordingly
  static void _handleNotificationPayload(String payload) {
    debugPrint('Handling notification payload: $payload');

    if (payload == 'tests') {
      try {
        // Ensure we're navigating from the root
        AppRouter.router.go(AppRouter.bottomTab); // Reset to home first
        Future.delayed(const Duration(milliseconds: 100), () {
          AppRouter.router.pushNamed(AppRouter.transcriptTest);
        });
      } catch (e) {
        debugPrint('Error navigating from notification: $e');
        // Fallback: try alternative navigation method
        Future.delayed(const Duration(milliseconds: 500), () {
          try {
            AppRouter.router.goNamed(AppRouter.bottomTab);
            AppRouter.router.pushNamed(AppRouter.transcriptTest);
          } catch (e2) {
            debugPrint('Fallback navigation also failed: $e2');
          }
        });
      }
    }
  }

  // Call this method after your app's routing is fully initialized
  static Future<void> handlePendingNotification() async {
    if (_pendingPayload != null) {
      debugPrint('Handling pending notification payload: $_pendingPayload');
      _handleNotificationPayload(_pendingPayload!);
      _pendingPayload = null;
    }
  }

  // REQUEST PERMISSION
  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final int sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      if (sdkInt >= 33) {
        final PermissionStatus status = await Permission.notification.status;
        if (!status.isGranted) {
          await Permission.notification.request();
        }
      }
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  // NOTIFICATIONS DETAIL SETUP
  NotificationDetails noficationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          autoCancel: true),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  void showFlutterNotification({
    required String title,
    required String content,
    String? payload,
  }) async {
    final now = DateTime.now().toIso8601String();
    await flutterLocalNotificationsPlugin.show(
      now.hashCode,
      title,
      content,
      noficationDetails(),
      payload: payload,
    );
  }

  // SCHEDULE NOTIFICATION
  Future<void> scheduleDailyNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(111);
      await AlarmPermissionService().requestExactAlarmPermissionIfNeeded();
      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

      debugPrint('Scheduling notification with ID: 111 at $scheduledDate');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        111,
        title,
        body,
        scheduledDate,
        noficationDetails(),
        payload: 'tests',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      // get pending notification
      final pendingNotificationRequests =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      debugPrint(
          'Pending Notification Requests: ${pendingNotificationRequests.length}');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    return scheduledTime;
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

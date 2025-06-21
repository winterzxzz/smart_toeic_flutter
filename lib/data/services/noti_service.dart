import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:toeic_desktop/data/services/alarm_permission_service.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

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

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  void showFlutterNotification({
    required String title,
    required String content,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      title.hashCode,
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
      final int notificationId = title.hashCode;
      await flutterLocalNotificationsPlugin.cancel(notificationId);
      await AlarmPermissionService().requestExactAlarmPermissionIfNeeded();
      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

      debugPrint(
          'Scheduling notification with ID: $notificationId at $scheduledDate');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        noficationDetails(),
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

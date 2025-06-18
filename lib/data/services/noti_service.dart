import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:toeic_desktop/common/router/route_config.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initTimeZone() async {
    tz.initializeTimeZones();
  }

  // INITIALIZE
  Future<void> initialize() async {
    if (_isInitialized) return;
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
      // Android 13+ requires runtime notification permission
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
      await cancelAllNotifications();
      await requestAlarmPermission();
      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        scheduledDate,
        noficationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
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
    debugPrint('Scheduled Time: ${scheduledTime.toIso8601String()}');
    return scheduledTime;
  }

  Future<void> requestAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        final PermissionStatus status =
            await Permission.scheduleExactAlarm.status;
        if (!status.isGranted) {
          const intent = AndroidIntent(
            action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
          // Show dialog to user
          showDialog(
            context: AppRouter.navigationKey.currentContext!,
            builder: (context) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                'Please enable "Schedule Exact Alarm" permission in the settings, then return to the app.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

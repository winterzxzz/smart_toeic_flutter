import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class AlarmPermissionService {
  static const MethodChannel _alarmChannel =
      MethodChannel('exact_alarm_channel');

  Future<void> requestExactAlarmPermissionIfNeeded() async {
    if (!Platform.isAndroid) return;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 31) {
      final bool isGranted =
          await _alarmChannel.invokeMethod('isExactAlarmGranted');
      if (!isGranted) {
        await _alarmChannel.invokeMethod('requestExactAlarmPermission');
      }
    }
  }
}

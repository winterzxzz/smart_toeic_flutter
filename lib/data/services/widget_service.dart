import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class WidgetService {
  static const MethodChannel _channel =
      MethodChannel('com.example.toeic_desktop/widget');

  /// Update widget color immediately
  static Future<String?> updateWidgetColor(String colorHex) async {
    try {
      final String? result = await _channel.invokeMethod('updateWidgetColor', {
        'colorHex': colorHex,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to update widget color: '${e.message}'.");
      return null;
    }
  }

  /// Schedule widget update after 2 minutes
  static Future<String?> scheduleWidgetUpdateAfter2Minutes({
    String? colorHex,
    List<String>? colorList,
    String updateType = 'color',
  }) async {
    try {
      final String? result =
          await _channel.invokeMethod('scheduleWidgetUpdateAfter2Minutes', {
        if (colorHex != null) 'colorHex': colorHex,
        if (colorList != null) 'colorList': colorList,
        'updateType': updateType,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule widget update: '${e.message}'.");
      return null;
    }
  }

  /// Schedule widget update after custom delay
  static Future<String?> scheduleWidgetUpdateAfterDelay({
    required int delayMinutes,
    String? colorHex,
    List<String>? colorList,
    String updateType = 'color',
  }) async {
    try {
      final String? result =
          await _channel.invokeMethod('scheduleWidgetUpdateAfterDelay', {
        'delayMinutes': delayMinutes,
        if (colorHex != null) 'colorHex': colorHex,
        if (colorList != null) 'colorList': colorList,
        'updateType': updateType,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule widget update: '${e.message}'.");
      return null;
    }
  }

  /// Cancel all scheduled widget updates
  static Future<String?> cancelWidgetUpdates() async {
    try {
      final String? result = await _channel.invokeMethod('cancelWidgetUpdates');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to cancel widget updates: '${e.message}'.");
      return null;
    }
  }
}

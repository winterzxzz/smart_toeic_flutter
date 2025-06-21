import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:toeic_desktop/data/models/ui_models/flash_card_show_in_widget.dart';

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

  /// Periodic widget update after 2 minutes
  static Future<String?> schedulePeriodicWidgetUpdate({
    required FlashCardShowInWidgetList flashCardShowInWidgetList,
  }) async {
    try {
      final json = flashCardShowInWidgetList.toJson();
      final String? result =
          await _channel.invokeMethod('schedulePeriodicWidgetUpdate', {
        'flashCardShowInWidgetList': json,
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

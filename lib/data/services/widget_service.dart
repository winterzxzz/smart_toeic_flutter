import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:toeic_desktop/data/models/ui_models/flash_card_show_in_widget.dart';

class WidgetService {
  static const MethodChannel _channel =
      MethodChannel('com.example.toeic_desktop/widget');

  /// Periodic widget update after 15 minutes
  Future<String?> schedulePeriodicWidgetUpdate({
    required FlashCardShowInWidgetList flashCardShowInWidgetList,
  }) async {
    try {
      final json = flashCardShowInWidgetList.toJson();
      final String? result =
          await _channel.invokeMethod('schedulePeriodicWidgetUpdate', {
        'flashCardShowInWidgetList': json,
      });
      debugPrint("Schedule widget update: $result");
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule widget update: '${e.message}'.");
      return null;
    }
  }

  Future<String?> updateReminderWordAfterTime({
    required String reminderWordAfterTime,
  }) async {
    try {
      final String? result =
          await _channel.invokeMethod('updateReminderWordAfterTime', {
        'reminderWordAfterTime': reminderWordAfterTime,
      });
      debugPrint("Update reminder word after time: $result");
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to update reminder word after time: '${e.message}'.");
      return null;
    }
  }

  Future<String?> cancelWidgetUpdate() async {
    try {
      final String? result = await _channel.invokeMethod('cancelWidgetUpdate');
      debugPrint("Cancel widget update: $result");
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to cancel widget update: '${e.message}'.");
      return null;
    }
  }
}

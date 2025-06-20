import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateHomeWidgetService {
  static const String _stringChannel = 'com.example.toeic_desktop/widget';
  static const MethodChannel _channel = MethodChannel(_stringChannel);

  Future<void> updateColor(String hexColor) async {
    try {
      await _channel.invokeMethod('updateWidgetColor', {
        'colorHex': hexColor,
      });
    } catch (e) {
      debugPrint("Widget color update failed: $e");
    }
  }
}

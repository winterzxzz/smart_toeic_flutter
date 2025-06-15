import 'package:flutter/services.dart';

class VoskService {
  static const MethodChannel _channel = MethodChannel('vosk_channel');

  Future<void> startListening() async {
    await _channel.invokeMethod('startListening');
  }

  Future<String> stopListening() async {
    final result = await _channel.invokeMethod('stopListening');
    return result.toString();
  }
}

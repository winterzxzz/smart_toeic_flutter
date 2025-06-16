import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

enum SpeechStatus {
  listening('listening'),
  notListening('notListening'),
  done('done'),
  error('error');

  final String value;
  const SpeechStatus(this.value);
}

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;

  final StreamController<SpeechStatus> _statusController =
      StreamController<SpeechStatus>.broadcast();
  Stream<SpeechStatus> get statusStream => _statusController.stream;

  bool get isInitialized => _isInitialized;

  // get status
  void handleListenStatus(SpeechStatus status) {
    debugPrint('winter-handleListenStatus: $status');
    _statusController.add(status);
  }

  void handleListenError(SpeechStatus error) {
    _statusController.add(error);
  }

  Future<bool> initialize() async {
    debugPrint('winter-initialize');
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        final speechStatus = SpeechStatus.values.firstWhere(
          (e) => e.value == status,
          orElse: () => SpeechStatus.notListening,
        );
        handleListenStatus(speechStatus);
      },
      onError: (error) {
        handleListenError(SpeechStatus.error);
      },
    );

    return _isInitialized;
  }

  void startListening(Function(String recognizedText) onResult) {
    if (!_isInitialized) return;
    _speech.listen(
      listenOptions: SpeechListenOptions(
        sampleRate: 44100,
        listenMode: ListenMode.dictation,
        partialResults: false,
        cancelOnError: false,
      ),
      localeId: 'en_US',
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10),
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }

  void cancelListening() {
    if (_speech.isListening) {
      _speech.cancel();
    }
  }

  bool get isListening => _speech.isListening;

  void dispose() {
    _statusController.close();
  }
}

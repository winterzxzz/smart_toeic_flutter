import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'voice_wave.dart';

class SpeechTest extends StatefulWidget {
  const SpeechTest({super.key});

  @override
  State<SpeechTest> createState() => _SpeechTestState();
}

class _SpeechTestState extends State<SpeechTest> {
  bool isEnable = false;
  final SpeechToText speechToText = SpeechToText();
  static const int barCount = 48;
  List<double> levels = List.filled(barCount, 0.0);
  String recognizedText = '';

  @override
  void initState() {
    super.initState();
    speechToText
        .initialize(
      finalTimeout: const Duration(seconds: 10),
      onError: (error) {
        debugPrint('error: $error');
      },
      onStatus: (status) {
        debugPrint('status: $status');
      },
    )
        .then((value) {
      setState(() {
        isEnable = value;
      });
    });
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  void _startSpeechToText() async {
    if (!isEnable) {
      debugPrint('SpeechToText is not initialized');
      return;
    }
    await speechToText.listen(
      onResult: (result) {
        setState(() {
          recognizedText += ' ${result.recognizedWords}';
        });
        debugPrint('text: ${result.recognizedWords}');
      },
      onSoundLevelChange: (level) {
        setState(() {
          levels.add(level);
          if (levels.length > barCount) {
            levels.removeAt(0);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Kiểm tra phát âm'),
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: levels.last / 100),
              ),
              child: IconButton(
                onPressed: isEnable ? _startSpeechToText : null,
                icon: const Icon(Icons.mic),
              ),
            ),
            VoiceWave(levels: levels),
            if (recognizedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  recognizedText,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

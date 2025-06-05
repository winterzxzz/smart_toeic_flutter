import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTest extends StatefulWidget {
  const SpeechTest({super.key});

  @override
  State<SpeechTest> createState() => _SpeechTestState();
}

class _SpeechTestState extends State<SpeechTest> {
  bool isEnable = false;
  final SpeechToText speechToText = SpeechToText();
  double level = 0.0;

  @override
  void initState() {
    super.initState();
    speechToText.initialize(
      onError: (error) {
        debugPrint('error: $error');
      },
      onStatus: (status) {
        debugPrint('status: $status');
      },
    ).then((value) {
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
        debugPrint('text: ${result.recognizedWords}');
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
                color: Colors.blue.withValues(alpha: level / 100),
              ),
              child: IconButton(
                onPressed: isEnable ? _startSpeechToText : null,
                icon: const Icon(Icons.mic),
              ),
            ),
            Text('Volume Level: ${level.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTest extends StatefulWidget {
  const SpeechTest({super.key});

  @override
  State<SpeechTest> createState() => _SpeechTestState();
}

class _SpeechTestState extends State<SpeechTest> {
  late SpeechToText speechToText;
  double level = 0.0;

  @override
  void initState() {
    super.initState();
    speechToText = SpeechToText()..initialize();
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  void _startSpeechToText() async {
    await speechToText.listen(
      onResult: (result) {
        log(result.recognizedWords);
      },
    );
  }

  // void _stopSpeechToText() {
  //   speechToText.stop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Thực hành phát âm'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Kiểm tra phát âm'),
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: level / 100),
              ),
              child: IconButton(
                onPressed: () {
                  _startSpeechToText();
                },
                icon: Icon(Icons.mic),
              ),
            ),
            Text('Volume Level: ${level.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

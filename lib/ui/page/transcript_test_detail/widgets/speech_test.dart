import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'voice_wave.dart';

class SpeechTest extends StatefulWidget {
  const SpeechTest({super.key, required this.onSave});

  final Function(String) onSave;

  @override
  State<SpeechTest> createState() => _SpeechTestState();
}

class _SpeechTestState extends State<SpeechTest> {
  bool isInitialized = false;
  bool isRecording = false;
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
        if (!mounted) return;
        setState(() {
          isRecording = false;
        });
        debugPrint('error: $error');
      },
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() {
            isRecording = false;
          });
        }
        debugPrint('status: $status');
      },
    )
        .then((value) {
      if (!mounted) return;
      setState(() {
        isInitialized = value;
      });
    });
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  void _startSpeechToText() async {
    if (!isInitialized) {
      debugPrint('SpeechToText is not initialized');
      return;
    }
    await speechToText.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          recognizedText += ' ${result.recognizedWords}';
        });
        debugPrint('text: ${result.recognizedWords}');
      },
      onSoundLevelChange: (level) {
        if (!mounted) return;
        setState(() {
          levels.add(level);
          if (levels.length > barCount) {
            levels.removeAt(0);
          }
        });
      },
    ).then((value) {
      if (!mounted) return;
      setState(() {
        isRecording = true;
      });
    });
  }

  void _stopSpeechToText() async {
    await speechToText.stop().then((value) {
      if (!mounted) return;
      setState(() {
        isRecording = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text('Kiểm tra phát âm'),
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording ? colorScheme.primary : null,
              ),
              child: IconButton(
                onPressed: isRecording ? _stopSpeechToText : _startSpeechToText,
                icon: Icon(
                  Icons.mic,
                  size: 32,
                  color: isRecording ? colorScheme.onPrimary : null,
                ),
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
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                onPressed: () {
                  widget.onSave(recognizedText);
                  GoRouter.of(context).pop(recognizedText);
                },
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

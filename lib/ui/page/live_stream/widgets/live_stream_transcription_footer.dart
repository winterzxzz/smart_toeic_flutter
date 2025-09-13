import 'package:flutter/cupertino.dart';

class LiveStreamTranscriptionFooter extends StatelessWidget {
  final String transcription;
  const LiveStreamTranscriptionFooter({super.key, required this.transcription});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(transcription),
    );
  }
}

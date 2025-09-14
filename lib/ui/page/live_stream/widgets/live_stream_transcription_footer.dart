import 'package:flutter/cupertino.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class LiveStreamTranscriptionFooter extends StatelessWidget {
  final String transcription;
  const LiveStreamTranscriptionFooter({super.key, required this.transcription});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        transcription,
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}

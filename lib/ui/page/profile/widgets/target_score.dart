import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class TargetScoreWidget extends StatelessWidget {
  const TargetScoreWidget({
    super.key,
    required this.title,
    this.currentScore = 0,
    this.targetScore = 0,
  });

  final String title;
  final int? currentScore;
  final int? targetScore;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleSmall,
              ),
            ),
            Text.rich(
              TextSpan(
                text: '$currentScore',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '/$targetScore',
                    style: textTheme.bodySmall,
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(8),
          backgroundColor: colorScheme.primary.withValues(alpha: 0.3),
          color: colorScheme.primary,
          minHeight: 5,
          value: (currentScore! >= targetScore!)
              ? 1
              : currentScore! / (targetScore! > 0 ? targetScore! : 1),
        ),
      ],
    );
  }
}

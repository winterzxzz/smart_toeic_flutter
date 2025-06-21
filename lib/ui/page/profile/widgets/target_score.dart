import 'package:flutter/material.dart';

class TargetScoreWidget extends StatelessWidget {
  const TargetScoreWidget({
    super.key,
    required this.title,
    this.currentScore,
    this.targetScore,
  });

  final String title;
  final int? currentScore;
  final int? targetScore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
            ),
            Text.rich(
              TextSpan(
                text: '${currentScore ?? 0}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '/${targetScore ?? 0}',
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(8),
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          color: theme.colorScheme.primary,
          minHeight: 5,
          value: currentScore != null ? currentScore! / (targetScore ?? 0) : 0,
        ),
      ],
    );
  }
}

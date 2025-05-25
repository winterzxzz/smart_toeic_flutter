
import 'package:flutter/material.dart';

class TargetScoreWidget extends StatelessWidget {
  const TargetScoreWidget({
    super.key,
    required this.title,
    this.targetScore,
  });

  final String title;
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
                text: '${targetScore ?? 0}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '/450',
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
          backgroundColor: Colors.grey,
          color: theme.brightness == Brightness.dark
              ? Colors.white
              : theme.primaryColor,
          minHeight: 5,
          value: targetScore != null ? targetScore! / 450 : 0,
        ),
      ],
    );
  }
}

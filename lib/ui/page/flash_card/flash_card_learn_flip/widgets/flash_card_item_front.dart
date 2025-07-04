import 'package:flutter/material.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class FlashcardFront extends StatelessWidget {
  final String word;

  const FlashcardFront({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            word,
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            S.current.click_to_reveal,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class FlashcardBack extends StatelessWidget {
  final FlashCard flashcard;

  const FlashcardBack({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Translate: ${flashcard.translation}',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Definition:',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            flashcard.definition,
            style: textTheme.bodyMedium,
          ),
          if (flashcard.exampleSentence.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Examples:',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...flashcard.exampleSentence.map((example) => Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        example,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Text(
              'Note: ',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              flashcard.note,
              style: textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

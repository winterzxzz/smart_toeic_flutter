import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_item.dart';

class SetFlashCardGrid extends StatelessWidget {
  const SetFlashCardGrid({super.key, required this.flashcards});

  final List<SetFlashCard> flashcards;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: flashcards
          .map(
            (item) => SetFlashCardItem(flashcard: item),
          )
          .toList(),
    );
  }
}

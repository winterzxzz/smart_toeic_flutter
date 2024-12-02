import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/set_flash_card_item.dart';

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
            (item) => SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width / 4,
              child: FlashcardItem(flashcard: item),
            ),
          )
          .toList(),
    );
  }
}

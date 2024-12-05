import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_learning_item.dart';

class SetFlashCardLearningGrid extends StatelessWidget {
  const SetFlashCardLearningGrid({super.key, required this.flashcards});

  final List<SetFlashCardLearning> flashcards;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: flashcards
          .map(
            (item) => SetFlashCardLearningItem(flashcard: item),
          )
          .toList(),
    );
  }
}

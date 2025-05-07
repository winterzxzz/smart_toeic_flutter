import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_learning_item.dart';

class SetFlashCardLearningGrid extends StatelessWidget {
  const SetFlashCardLearningGrid({super.key, required this.flashcards});

  final List<SetFlashCardLearning> flashcards;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flashcards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SetFlashCardLearningItem(flashcard: flashcards[index]);
      },
    );
  }
}

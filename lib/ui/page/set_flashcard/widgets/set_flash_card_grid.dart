import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_item.dart';

class SetFlashCardGrid extends StatelessWidget {
  const SetFlashCardGrid({super.key, required this.flashcards});

  final List<SetFlashCard> flashcards;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flashcards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SetFlashCardItem(flashcard: flashcards[index]);
      },
    );
  }
}

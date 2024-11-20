import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_item.dart';

class FlashcardGrid extends StatelessWidget {
  const FlashcardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 180,
      ),
      itemCount: Constants.flashcards.length,
      itemBuilder: (context, index) {
        final item = Constants.flashcards[index];
        return FlashcardItem(flashcard: item);
      },
    );
  }
}

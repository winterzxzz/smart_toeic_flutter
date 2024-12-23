import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';

class MatchingWord extends StatelessWidget {
  const MatchingWord({super.key, required this.list});

  final List<FlashCardLearning> list;

  @override
  Widget build(BuildContext context) {
    final shuffledWords = [...list]..shuffle();
    final shuffledTranslations = [...list]..shuffle();

    return Column(
      children: [
        Text('Ghép nghĩa', style: TextStyle(fontSize: 18)),
        SizedBox(height: 32),
        Row(
          children: [
            // English
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: shuffledWords.map((fc) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(fc.flashcardId!.word),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 32),
            // Vietnamese
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: shuffledTranslations.map((fc) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(fc.flashcardId!.translation),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

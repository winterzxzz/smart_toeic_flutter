import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class FlashcardBack extends StatelessWidget {
  final FlashCard flashcard;

  const FlashcardBack({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.6,
      height: MediaQuery.sizeOf(context).height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Translate: ${flashcard.translation}',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Definition:',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            flashcard.definition,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          if (flashcard.exampleSentence.isNotEmpty) ...[
            SizedBox(height: 16),
            Text(
              'Examples:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            ...flashcard.exampleSentence.map((example) => Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      example,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                )),
            SizedBox(height: 16),
            Text(
              'Note: ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              flashcard.note,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }
}

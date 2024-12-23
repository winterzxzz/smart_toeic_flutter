

import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class OrderWordToCorrect extends StatelessWidget {
  const OrderWordToCorrect({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  Widget build(BuildContext context) {
    final shuffledWords = [
      ...fcLearning.flashcardId!.exampleSentence.first.split(' ')
    ];
    shuffledWords.shuffle();
    return Column(
      key: key,
      children: [
        Text('Sắp xếp các từ để tạo thành câu đúng'),
        SizedBox(height: 32),
        Row(
          children: [
            ...shuffledWords.map((word) {
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gray2,
                      border: Border.all(color: AppColors.gray1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.gray2,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Kiểm tra'),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Xem đáp án'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
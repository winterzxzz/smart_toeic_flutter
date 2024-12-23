

import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';

class SelectTranslation extends StatelessWidget {
  const SelectTranslation({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        Text.rich(
          style: TextStyle(fontSize: 18),
          TextSpan(
            children: [
              TextSpan(text: 'Chọn nghĩa đúng cho từ '),
              TextSpan(
                text: "'${fcLearning.flashcardId!.word}'",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' ?'),
            ],
          ),
        ),
        SizedBox(height: 32),
        ...fcLearning.flashcardId!.translation.split('.').map((level) {
          return Column(
            children: [
              const SizedBox(height: 32),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: level,
                        groupValue: null,
                        onChanged: (value) {},
                      ),
                      SizedBox(width: 8),
                      Expanded(child: Text(level)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
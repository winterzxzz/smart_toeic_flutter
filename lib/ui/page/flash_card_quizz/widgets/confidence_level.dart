


import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';


const diffLevels = [
  {'value': 0, 'label': 'Khó nhớ'},
  {'value': 0.3, 'label': 'Tương đối khó'},
  {'value': 0.6, 'label': 'Dễ nhớ'},
  {'value': 1, 'label': 'Rất dễ nhớ'},
];

class ConfidenceLevel extends StatelessWidget {
  const ConfidenceLevel({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        Text(
          fcLearning.flashcardId!.word,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Bạn đã thuộc từ này ở mức nào?',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 32),
        ...diffLevels.map((level) {
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
                        value: level['value'].toString(),
                        groupValue: null,
                        onChanged: (value) {},
                      ),
                      SizedBox(width: 8),
                      Text(level['label'].toString()),
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
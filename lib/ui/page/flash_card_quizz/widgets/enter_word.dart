

import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class EnterWord extends StatelessWidget {
  const EnterWord({super.key, required this.fcLearning});

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
              TextSpan(text: 'Nhập từ tiếng Việt có nghĩa là '),
              TextSpan(
                text: "'${fcLearning.flashcardId!.word}'",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.error),
              ),
              TextSpan(text: ' ?'),
            ],
          ),
        ),
        SizedBox(height: 32),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Nhập từ tiếng Việt',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.purple),
            ),
          ),
          onChanged: (value) {},
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
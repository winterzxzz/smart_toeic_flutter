import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class FlashcardFront extends StatelessWidget {
  final String word;

  const FlashcardFront({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            word,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Click to reveal definition',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

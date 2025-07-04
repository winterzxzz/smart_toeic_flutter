import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/question_explain.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class ExplanationUI extends StatelessWidget {
  const ExplanationUI({super.key, required this.questionExplain});

  final QuestionExplain questionExplain;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.explanation,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Cards
          ...questionExplain.options.map((e) {
            final isCorrect = e.label == questionExplain.correctAnswer;
            final des = isCorrect
                ? questionExplain.explanation.correctReason
                : questionExplain.explanation.incorrectReasons
                    .getReason(e.label);
            return ExplanationCard(
              title: '${e.label}. ${e.text}',
              description: des,
              isCorrect: isCorrect,
            );
          }),
        ],
      ),
    );
  }
}

class ExplanationCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isCorrect;

  const ExplanationCard({
    super.key,
    required this.title,
    required this.description,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final color = isCorrect ? colorScheme.primary : AppColors.error;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

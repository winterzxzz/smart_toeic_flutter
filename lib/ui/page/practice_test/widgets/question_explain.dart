import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/question_explain.dart';

class ExplanationUI extends StatelessWidget {
  const ExplanationUI({super.key, required this.questionExplain});

  final QuestionExplain questionExplain;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explanations:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 12),
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
    final color = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

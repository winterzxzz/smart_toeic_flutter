import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/audio_section.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.question,
  });
  final Question question;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.audio != null) AudioSection(audioUrl: question.audio!),
          if (question.image != null)
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Image.network(
                question.image!,
              ),
            ),
          if (question.image != null) const SizedBox(height: 16),
          const SizedBox(
            height: 16,
          ),
          QuestionInfoWidget(
            questionNumber: question.id,
            questionContent: question.question,
            options: question.option4 != null
                ? [
                    question.option1,
                    question.option2,
                    question.option3,
                    question.option4,
                  ]
                : [
                    question.option1,
                    question.option2,
                    question.option3,
                  ],
          ),
        ],
      ),
    );
  }
}

class QuestionInfoWidget extends StatelessWidget {
  const QuestionInfoWidget({
    super.key,
    required this.questionNumber,
    this.questionContent,
    required this.options,
  });

  final int questionNumber;
  final String? questionContent;
  final List<String?> options;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '$questionNumber',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16.0),
        // Options
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (questionContent != null) Text(questionContent!),
              ...List.generate(options.length, (index) {
                String optionLabel =
                    String.fromCharCode(65 + index); // A, B, C, D
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: null, // Default selected value
                      activeColor: Colors.red,
                      onChanged: (value) {},
                    ),
                    Text(
                      "$optionLabel.",
                    ),
                    const SizedBox(width: 8),
                    if (options[index] != null) Text(options[index] ?? ''),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

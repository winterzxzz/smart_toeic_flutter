import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/audio_section.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.question,
  });
  final QuestionModel question;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(question.id),
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
            question: question,
          ),
        ],
      ),
    );
  }
}

class QuestionInfoWidget extends StatelessWidget {
  const QuestionInfoWidget({
    super.key,
    required this.question,
  });
  final QuestionModel question;

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
                '${question.id}',
                style: const TextStyle(
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
              if (question.question != null && question.part > 2)
                Text(question.question ?? ''),
              Builder(builder: (context) {
                return Column(children: [
                  ...List.generate(
                    question.options.length,
                    (index) {
                      final option = question.options[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio<String>(
                            value: option.id.name,
                            groupValue:
                                question.userAnswer, // Default selected value
                            activeColor: Colors.red,
                            onChanged: (value) {
                              context
                                  .read<PracticeTestCubit>()
                                  .setUserAnswer(question, value!);
                            },
                          ),
                          Text(
                            '${option.id.name}. ',
                          ),
                          if (question.part > 2)
                            Column(
                              children: [
                                const SizedBox(width: 8),
                                Text(option.content.toString()),
                              ],
                            )
                        ],
                      );
                    },
                  ),
                ]);
              })
            ],
          ),
        ),
      ],
    );
  }
}

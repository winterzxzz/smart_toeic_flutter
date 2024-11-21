import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.startNumber,
    required this.indexQuestion,
    this.urlAudio,
    this.urlImage,
    this.questionContent,
    this.numbersOfAnswers = 4,
    this.options,
  });
  final int startNumber;
  final int indexQuestion;
  final String? urlAudio;
  final String? urlImage;
  final String? questionContent;
  final int numbersOfAnswers;
  final List<String>? options;
  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.urlAudio != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gray3,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 1,
                      value: Random().nextDouble() * 1,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
          if (widget.urlAudio != null) const SizedBox(height: 16),
          if (widget.urlImage != null)
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Image.network(
                widget.urlImage!,
              ),
            ),
          if (widget.urlImage != null) const SizedBox(height: 16),
          const SizedBox(
            height: 16,
          ),
          QuestionInfoWidget(
            startNumber: widget.startNumber,
            indexQuestion: widget.indexQuestion,
            numbersOfAnswers: widget.numbersOfAnswers,
            questionContent: widget.questionContent,
            options: widget.options,
          ),
        ],
      ),
    );
  }
}

class QuestionInfoWidget extends StatelessWidget {
  const QuestionInfoWidget(
      {super.key,
      required this.startNumber,
      required this.indexQuestion,
      required this.numbersOfAnswers,
      this.questionContent,
      this.options});

  final int startNumber;
  final int indexQuestion;
  final int numbersOfAnswers;
  final String? questionContent;
  final List<String>? options;
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
                '${startNumber + indexQuestion}',
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
              ...List.generate(numbersOfAnswers, (index) {
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
                    if (options != null) const SizedBox(width: 8),
                    if (options != null) Text(options![index]),
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

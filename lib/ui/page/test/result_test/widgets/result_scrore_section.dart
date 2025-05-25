import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/page/test/result_test/widgets/result_score_box.dart';

class ResultScoreSection extends StatelessWidget {
  const ResultScoreSection({super.key, required this.resultModel});

  final ResultModel resultModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ResultScoreBox(
                label: 'Correct',
                value: '${resultModel.correctQuestion}',
                color: Colors.green,
                icon: FontAwesomeIcons.circleCheck,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ResultScoreBox(
                label: 'Incorrect',
                value: '${resultModel.incorrectQuestion}',
                color: Colors.red,
                icon: FontAwesomeIcons.circleXmark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ResultScoreBox(
                label: 'Skip',
                value: '${resultModel.notAnswerQuestion}',
                color: Colors.grey,
                icon: FontAwesomeIcons.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ResultScoreBox(
                label: 'Score',
                value: '${resultModel.overallScore}',
                color: Colors.blue,
                icon: FontAwesomeIcons.flag,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

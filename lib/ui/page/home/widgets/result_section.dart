import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/ui/page/home/widgets/result_card.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key, required this.results});

  final List<ResultTest> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Your Exam Results",
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                fontWeightDelta: 2,
              ),
        ),
        const SizedBox(height: 16),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: results
                .map((e) => Expanded(child: ExamResultCard(result: e)))
                .toList())
      ],
    );
  }
}

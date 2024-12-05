import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/home/widgets/result_card.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key, required this.results});

  final List<ResultTest> results;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          Text(
            "Your Exam Results",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: AppColors.textBlack,
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
      ),
    );
  }
}

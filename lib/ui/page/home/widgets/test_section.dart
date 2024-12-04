import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/test_online/widgets/test_card.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key, required this.tests});

  final List<Test> tests;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            "TOEIC Exam",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: AppColors.textBlack,
                  fontWeightDelta: 2,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tests
                .map((e) => Expanded(
                    child: SizedBox(height: 210, child: TestCard(test: e))))
                .toList(),
          )
        ],
      ),
    );
  }
}

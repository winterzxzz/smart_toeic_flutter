import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/ui/page/home/widgets/result_card.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key, required this.results});

  final List<ResultTest> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Exam Results",
              style: Theme.of(context).textTheme.titleLarge!.apply(
                    fontWeightDelta: 2,
                  ),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(AppRouter.historyTest);
              },
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        Column(
          children: results.map((e) => ExamResultCard(result: e)).toList(),
        )
      ],
    );
  }
}

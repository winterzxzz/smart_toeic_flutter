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
          children: [
            const SizedBox(width: 16),
            IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: 0,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Xem tất cả'),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Your Exam Results",
              style: Theme.of(context).textTheme.headlineMedium!.apply(
                    fontWeightDelta: 2,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(AppRouter.historyTest);
              },
              child: Text('Xem tất cả'),
            ),
            const SizedBox(width: 16),
          ],
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

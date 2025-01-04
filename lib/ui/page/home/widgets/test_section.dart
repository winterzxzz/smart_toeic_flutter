import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/ui/page/test_online/widgets/test_card.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key, required this.tests});

  final List<Test> tests;

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
              "TOEIC Exam",
              style: Theme.of(context).textTheme.headlineMedium!.apply(
                    fontWeightDelta: 2,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go(AppRouter.onlineTest);
              },
              child: Text('Xem tất cả'),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              tests.map((e) => Expanded(child: TestCard(test: e))).toList(),
        )
      ],
    );
  }
}

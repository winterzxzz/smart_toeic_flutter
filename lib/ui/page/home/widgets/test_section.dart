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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOEIC Exam",
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 2,
                    ),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).push(AppRouter.bottomTab);
                },
                child: Text('Xem tất cả'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: tests.map((e) => TestCard(test: e)).toList(),
        )
      ],
    );
  }
}

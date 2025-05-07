import 'package:flutter/material.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_cubit.dart';
import 'package:toeic_desktop/ui/page/test_online/widgets/test_card.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key, required this.tests});

  final List<Test> tests;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                injector<BottomTabCubit>().changeCurrentIndex(1);
              },
              child: Text('Xem tất cả'),
            ),
          ],
        ),
        Column(
          children: tests.map((e) => TestCard(test: e)).toList(),
        )
      ],
    );
  }
}

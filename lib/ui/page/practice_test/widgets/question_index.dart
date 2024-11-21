import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/practice_test_part.dart';

class QuestionIndex extends StatelessWidget {
  const QuestionIndex({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Thời gian làm bài:'),
          Text(
            "10:00",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 45,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'Nộp bài'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 1',
            numberQuestions: 6,
            startNumber: 1,
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 2',
            numberQuestions: 25,
            startNumber: 7,
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 3',
            numberQuestions: 39,
            startNumber: 32,
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 4',
            numberQuestions: 30,
            startNumber: 71,
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 5',
            numberQuestions: 30,
            startNumber: 101,
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 5',
            numberQuestions: 16,
            startNumber: 131,
          ),
          const SizedBox(
            height: 16,
          ),
          PracticeTestPart(
            title: 'Part 7',
            numberQuestions: 54,
            startNumber: 147,
          ),
        ],
      ),
    );
  }
}

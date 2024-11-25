import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/practice_test_part.dart';

class QuestionIndex extends StatefulWidget {
  const QuestionIndex({
    super.key,
  });

  @override
  State<QuestionIndex> createState() => _QuestionIndexState();
}

class _QuestionIndexState extends State<QuestionIndex> {
  late Duration remainingTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingTime = context.read<PracticeTestCubit>().state.duration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeTestCubit, PracticeTestState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
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
                Text('Thời gian còn lại:'),
                Text(
                  '${remainingTime.inMinutes}:${remainingTime.inSeconds % 60 < 10 ? '0' : ''}${remainingTime.inSeconds % 60}',
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
                ...state.parts.map((part) => Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        PracticeTestPart(
                          title: part.name,
                          questions: state.questions
                              .where(
                                  (question) => question.part == part.numValue)
                              .toList(),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

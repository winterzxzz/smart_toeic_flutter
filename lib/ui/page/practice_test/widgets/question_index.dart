import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
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
    final testShow = context.read<PracticeTestCubit>().state.testShow;
    if (testShow == TestShow.test) {
      remainingTime = context.read<PracticeTestCubit>().state.duration;
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - Duration(seconds: 1);
        });
      } else {
        context.read<PracticeTestCubit>().submitTest(context, remainingTime);
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
    return SingleChildScrollView(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
        ),
        child: BlocBuilder<PracticeTestCubit, PracticeTestState>(
          buildWhen: (previous, current) =>
              previous.parts != current.parts ||
              previous.questions != current.questions ||
              previous.testShow != current.testShow,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.testShow == TestShow.test)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thời gian còn lại:'),
                      Text(
                        '${remainingTime.inMinutes}:${remainingTime.inSeconds % 60 < 10 ? '0' : ''}${remainingTime.inSeconds % 60}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showConfirmSubmitTestDialog,
                          child: Text('Nộp bài'),
                        ),
                      ),
                    ],
                  ),
                ...state.parts.map(
                  (part) {
                    if (state.questions
                        .where(
                            (question) => question.part == part.numValue)
                        .isNotEmpty) {
                      return Column(
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
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showConfirmSubmitTestDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Nộp bài'),
        content: Text('Bạn có chắc chắn muốn nộp bài không?'),
        actions: [
          TextButton(
              onPressed: () {
                GoRouter.of(dialogContext).pop();
              },
              child: Text('Hủy')),
          TextButton(
              onPressed: () {
                context
                    .read<PracticeTestCubit>()
                    .submitTest(context, remainingTime);
              },
              child: Text(
                'Nộp bài',
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
  }
}

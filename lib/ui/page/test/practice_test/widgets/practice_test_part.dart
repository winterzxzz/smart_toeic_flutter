import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';

class PracticeTestPart extends StatefulWidget {
  const PracticeTestPart({
    super.key,
    required this.title,
    required this.questions,
  });

  final String title;
  final List<QuestionModel> questions;

  @override
  State<PracticeTestPart> createState() => _PracticeTestPartState();
}

class _PracticeTestPartState extends State<PracticeTestPart> {
  late final PracticeTestCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<PracticeTestCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: 50,
          ),
          itemCount: widget.questions.length,
          itemBuilder: (context, index) {
            final isAnswered = widget.questions[index].userAnswer != null;
            return GestureDetector(
              onTap: () {
                _cubit.setFocusQuestion(widget.questions[index]);
              },
              child: BlocBuilder<PracticeTestCubit, PracticeTestState>(
                buildWhen: (previous, current) =>
                    previous.questionsResult != current.questionsResult ||
                    previous.testShow != current.testShow,
                builder: (context, state) {
                  Color color =
                      theme.colorScheme.primary.withValues(alpha: 0.2);
                  if (state.testShow == TestShow.test) {
                    color = isAnswered ? theme.colorScheme.primary : color;
                  } else {
                    for (var questionResult in state.questionsResult) {
                      if (questionResult.questionNum ==
                          widget.questions[index].id.toString()) {
                        color = questionResult.correctanswer ==
                                questionResult.useranswer
                            ? AppColors.success
                            : AppColors.error;
                      }
                    }
                  }
                  return Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Icon(
                            isAnswered
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 20,
                            color: isAnswered ? Colors.white : null,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          widget.questions[index].id.toString(),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

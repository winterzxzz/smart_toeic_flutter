import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';

class PracticeTestPart extends StatelessWidget {
  const PracticeTestPart({
    super.key,
    required this.title,
    required this.questions,
  });

  final String title;
  final List<QuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 16,
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 5 items per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: 40,
          ),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context
                    .read<PracticeTestCubit>()
                    .setFocusQuestion(questions[index]);
              },
              child: BlocSelector<PracticeTestCubit, PracticeTestState,
                  List<QuestionModel>>(
                selector: (state) {
                  return state.questionsOfPart;
                },
                builder: (context, questionsOfPart) {
                  final isAnswered = questions[index].userAnswer != null;
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isAnswered
                          ? Colors.deepOrangeAccent
                          : Theme.of(context).brightness == Brightness.dark
                              ? AppColors.backgroundDarkSub
                              : AppColors.backgroundLightSub,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      '${questions[index].id}',
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

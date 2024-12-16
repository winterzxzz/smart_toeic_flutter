import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/audio_section.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.question,
  });
  final QuestionModel question;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(question.id),
      margin: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.audio != null) AudioSection(audioUrl: question.audio!),
          if (question.image != null)
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Image.network(
                question.image!,
              ),
            ),
          if (question.image != null) const SizedBox(height: 16),
          const SizedBox(
            height: 16,
          ),
          QuestionInfoWidget(
            question: question,
          ),
        ],
      ),
    );
  }
}

class QuestionInfoWidget extends StatelessWidget {
  const QuestionInfoWidget({
    super.key,
    required this.question,
  });
  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '${question.id}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16.0),
        // Options
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (question.question != null && question.part > 2)
                Text(question.question ?? ''),
              Builder(builder: (context) {
                return BlocBuilder<PracticeTestCubit, PracticeTestState>(
                  buildWhen: (previous, current) =>
                      previous.testShow != current.testShow ||
                      previous.questionsResult != current.questionsResult ||
                      previous.isShowAnswer != current.isShowAnswer,
                  builder: (context, state) {
                    if (state.testShow == TestShow.test) {
                      return Column(children: [
                        ...List.generate(
                          question.options.length,
                          (index) {
                            final option = question.options[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio<String>(
                                  value: option.id.name,
                                  groupValue: question
                                      .userAnswer, // Default selected value
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    context
                                        .read<PracticeTestCubit>()
                                        .setUserAnswer(question, value!);
                                  },
                                ),
                                Text(
                                  '${option.id.name}. ',
                                ),
                                if (question.part > 2)
                                  Column(
                                    children: [
                                      const SizedBox(width: 8),
                                      Text(option.content.toString()),
                                    ],
                                  )
                              ],
                            );
                          },
                        ),
                      ]);
                    } else {
                      final questionResult =
                          getQuestionResult(state.questionsResult);
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              question.options.length,
                              (index) {
                                final option = question.options[index];
                                Color? color;
                                if (questionResult?.useranswer ==
                                    option.id.name) {
                                  if (questionResult?.correctanswer ==
                                      option.id.name) {
                                    color = Colors.green.withOpacity(0.5);
                                  } else {
                                    color = Colors.red.withOpacity(0.5);
                                  }
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Radio<String>(
                                      value: option.id.name,
                                      groupValue: questionResult?.useranswer,
                                      activeColor: Colors.red,
                                      onChanged: null,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                      ),
                                      child: Text(
                                        '${option.id.name}. ',
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(width: 8),
                                        Text(option.content.toString()),
                                      ],
                                    )
                                  ],
                                );
                              },
                            ),
                            if (questionResult?.correctanswer !=
                                    questionResult?.useranswer ||
                                questionResult == null)
                              Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Correct answer: ${question.correctAnswer}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) {
                                final isPremium =
                                    state.user?.isPremium() ?? false;
                                if (!isPremium) {
                                  return Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          GoRouter.of(context).goNamed(
                                              AppRouter.upgradeAccount);
                                        },
                                        child: const Text(
                                          'Upgrade to use AI',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Add upgrade button
                                      SizedBox(
                                        width: 200,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: null,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons.robot,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                  'Tạo lời giải bằng AI'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return SizedBox(
                                    width: 200,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.lock,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Tạo lời giải bằng AI'),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          ]);
                    }
                  },
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  QuestionResult? getQuestionResult(List<QuestionResult> questionsResult) {
    for (var questionResult in questionsResult) {
      if (questionResult.questionNum == question.id.toString()) {
        return questionResult;
      }
    }
    return null;
  }
}

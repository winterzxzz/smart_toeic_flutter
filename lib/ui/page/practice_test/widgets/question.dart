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
import 'package:toeic_desktop/ui/page/practice_test/widgets/question_explain.dart';

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
          if (question.paragraph != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
              ),
              child: SelectionArea(
                child: Text(
                  question.paragraph!,
                ),
              ),
            ),
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

class QuestionInfoWidget extends StatefulWidget {
  const QuestionInfoWidget({
    super.key,
    required this.question,
  });
  final QuestionModel question;

  @override
  State<QuestionInfoWidget> createState() => _QuestionInfoWidgetState();
}

class _QuestionInfoWidgetState extends State<QuestionInfoWidget> {
  bool isLoading = false;

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
                '${widget.question.id}',
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
              if (widget.question.question != null && widget.question.part > 2)
                Text(widget.question.question ?? ''),
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
                          widget.question.options.length,
                          (index) {
                            final option = widget.question.options[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio<String>(
                                  value: option.id?.name ?? '',
                                  groupValue: widget.question
                                      .userAnswer, // Default selected value
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  onChanged: (value) {
                                    context
                                        .read<PracticeTestCubit>()
                                        .setUserAnswer(widget.question, value!);
                                  },
                                ),
                                Text(
                                  '${option.id?.name}. ',
                                ),
                                if (widget.question.part > 2)
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
                              widget.question.options.length,
                              (index) {
                                final option = widget.question.options[index];
                                Color? color;
                                if (questionResult?.useranswer ==
                                    option.id?.name) {
                                  if (questionResult?.correctanswer ==
                                      option.id?.name) {
                                    color = Colors.green.withValues(alpha: 0.5);
                                  } else {
                                    color = Colors.red.withValues(alpha: 0.5);
                                  }
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Radio<String>(
                                      value: option.id?.name ?? '',
                                      groupValue: questionResult?.useranswer,
                                      activeColor: Colors.red,
                                      onChanged: null,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                      ),
                                      child: Text(
                                        '${option.id?.name}. ',
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
                                    'Correct answer: ${widget.question.correctAnswer}',
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
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await context
                                                  .read<PracticeTestCubit>()
                                                  .getExplainQuestion(
                                                      widget.question)
                                                  .then((_) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                            },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (isLoading)
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Theme.of(context)
                                                            .brightness !=
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            )
                                          else
                                            const FaIcon(
                                              FontAwesomeIcons.lock,
                                              size: 14,
                                            ),
                                          const SizedBox(width: 8),
                                          const Text('Tạo lời giải bằng AI'),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            if (widget.question.questionExplain != null)
                              ExplanationUI(
                                questionExplain:
                                    widget.question.questionExplain!,
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
      if (questionResult.questionNum == widget.question.id.toString()) {
        return questionResult;
      }
    }
    return null;
  }
}

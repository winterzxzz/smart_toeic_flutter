import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question_explain.dart';

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
  late final PracticeTestCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<PracticeTestCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            '${widget.question.id}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Options
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
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
                      return RadioGroup<String>(
                        groupValue: widget.question.userAnswer ?? '',
                        onChanged: (value) {
                          if (value != null) {
                            cubit.setUserAnswer(widget.question, value);
                          }
                        },
                        child: Column(children: [
                          ...List.generate(
                            widget.question.options.length,
                            (index) {
                              final option = widget.question.options[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Radio<String>(
                                        value: option.id ?? '',
                                        toggleable: false,
                                        activeColor: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${option.id ?? ''}. ',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (option.content
                                          .toString()
                                          .trim()
                                          .isNotEmpty &&
                                      widget.question.part >= 3) ...[
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          option.content.toString().trim(),
                                          style: textTheme.bodyMedium?.copyWith(
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              );
                            },
                          ),
                        ]),
                      );
                    } else {
                      final questionResult =
                          getQuestionResult(state.questionsResult);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Radio options wrapped in IgnorePointer
                          IgnorePointer(
                            child: RadioGroup<String>(
                              groupValue: questionResult?.useranswer ?? '',
                              onChanged: (value) {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  widget.question.options.length,
                                  (index) {
                                    final option =
                                        widget.question.options[index];
                                    Color? color;
                                    if (questionResult?.useranswer ==
                                        option.id) {
                                      if (questionResult?.correctanswer ==
                                          option.id) {
                                        color =
                                            Colors.green.withValues(alpha: 0.5);
                                      } else {
                                        color =
                                            Colors.red.withValues(alpha: 0.5);
                                      }
                                    }
                                    return Container(
                                      color: color,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Radio<String>(
                                              value: option.id ?? '',
                                              toggleable: false,
                                              activeColor: Colors.red,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              '${option.id}.',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                option.content
                                                    .toString()
                                                    .trim(),
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Correct answer text (outside IgnorePointer)
                          if (questionResult?.correctanswer.trim() !=
                                  questionResult?.useranswer.trim() ||
                              questionResult == null)
                            Column(
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  '${S.current.correct_answer}: ${widget.question.correctAnswer}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          // AI Explain button (outside IgnorePointer - now clickable!)
                          if (widget.question.part >= 5) ...[
                            const SizedBox(height: 8),
                            BlocBuilder<UserCubit, UserState>(
                              builder: (context, userState) {
                                final isPremium =
                                    userState.user?.isPremium() ?? false;
                                if (!isPremium) {
                                  return CustomButton(
                                    height: 50,
                                    onPressed: () {
                                      GoRouter.of(context)
                                          .pushNamed(AppRouter.upgradeAccount);
                                    },
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
                                        Text(
                                          S.current.upgrade_to_use_ai,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return BlocBuilder<PracticeTestCubit,
                                          PracticeTestState>(
                                      buildWhen: (previous, current) =>
                                          previous.loadStatusExplain !=
                                              current.loadStatusExplain ||
                                          previous.loadingExplainQuestionId !=
                                              current.loadingExplainQuestionId,
                                      builder: (context, practiceState) {
                                        final isLoading = practiceState
                                                    .loadStatusExplain ==
                                                LoadStatus.loading &&
                                            practiceState
                                                    .loadingExplainQuestionId ==
                                                widget.question.id;
                                        return CustomButton(
                                          height: 50,
                                          isLoading: isLoading,
                                          onPressed: isLoading
                                              ? null
                                              : () async {
                                                  await cubit
                                                      .getExplainQuestion(
                                                          widget.question);
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (isLoading)
                                                const LoadingCircle(
                                                  size: 20,
                                                )
                                              else
                                                const FaIcon(
                                                  FontAwesomeIcons
                                                      .wandMagicSparkles,
                                                  size: 14,
                                                ),
                                              const SizedBox(width: 8),
                                              Text(
                                                S.current.create_answer_by_ai,
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }
                              },
                            )
                          ],
                          // Explanation UI (outside IgnorePointer)
                          if (widget.question.questionExplain != null) ...[
                            const SizedBox(height: 8),
                            ExplanationUI(
                              questionExplain: widget.question.questionExplain!,
                            )
                          ]
                        ],
                      );
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

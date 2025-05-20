import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/tag_widget.dart';

class ExamResultCard extends StatelessWidget {
  final ResultTest result;

  const ExamResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = [
      TagWidget(
        icon: FontAwesomeIcons.circleCheck,
        text:
            'Correct: ${result.numberOfCorrectAnswers}/${result.numberOfQuestions}',
        color: AppColors.success,
      ),
      TagWidget(
        icon: FontAwesomeIcons.penToSquare,
        text: 'Attempt: ${getCountAttempt(result)}',
        color: AppColors.primary,
      ),
      TagWidget(
        icon: FontAwesomeIcons.circleQuestion,
        text:
            'Answered: ${result.numberOfUserAnswers}/${result.numberOfQuestions}',
        color: AppColors.error,
      ),
    ];
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRouter.practiceTest, extra: {
            'testShow': TestShow.result,
            'resultId': result.id,
            'parts': result.parts.map((part) => part.partValue).toList(),
            'testId': result.testId.id,
            'duration': Duration(seconds: result.secondTime),
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    result.testId.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clock,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${result.secondTime}s',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.calendarPlus,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ' ${DateFormat('dd/MM/yyyy').format(result.createdAt)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 24,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return tags[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getCountAttempt(ResultTest result) {
    final currentUserId = injector<UserCubit>().state.user?.id;
    return result.testId.attempts
        .firstWhere((e) => e.userId == currentUserId,
            orElse: () => Attempt(userId: '', times: 0))
        .times;
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/time_utils.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class TestCard extends StatelessWidget {
  const TestCard({
    super.key,
    required this.test,
  });

  final Test test;

  @override
  Widget build(BuildContext context) {
    final userAttempt = test.userAttempt;
    final isAttempted = userAttempt!.count! > 0;
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: isAttempted == true ? 1 : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FaIcon(FontAwesomeIcons.circleCheck,
                      color: AppColors.success),
                ],
              ),
            ),
            if (test.title != null)
              Text(
                test.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              direction: Axis.horizontal,
              children: [
                TagWidget(
                    icon: FontAwesomeIcons.clock,
                    text: "${test.duration} minutes"),
                TagWidget(
                    icon: FontAwesomeIcons.turnUp,
                    text: "level: ${test.difficulty}"),
                TagWidget(
                  icon: FontAwesomeIcons.circleQuestion,
                  text: "${test.numberOfQuestions} questions",
                ),
                TagWidget(
                  icon: FontAwesomeIcons.circleCheck,
                  text: "${userAttempt.count!} attempts",
                ),
                TagWidget(
                  icon: FontAwesomeIcons.fileLines,
                  text: "Type: ${test.type}",
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isAttempted == true
                    ? AppColors.success.withValues(alpha: 0.2)
                    : Colors.grey[500],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAttempted
                        ? 'Have been ${userAttempt.count!} attempts'
                        : 'Manage your time effectively !',
                    style: TextStyle(
                      color:
                          isAttempted ? AppColors.success : AppColors.textWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isAttempted)
                    Row(
                      children: [
                        Icon(Icons.access_alarm,
                            color: AppColors.success, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          TimeUtils.timeAgo(test.updatedAt ?? test.createdAt!),
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAttempted ? AppColors.success : null,
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(AppRouter.modeTest, extra: {
                    'test': test,
                  });
                },
                child: Text(isAttempted ? "Retake Test" : "Take Test"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getCountAttempt(Test test) {
    return test.userAttempt?.count ?? 0;
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 16),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}

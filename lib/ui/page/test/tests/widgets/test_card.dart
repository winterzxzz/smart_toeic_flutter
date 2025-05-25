import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/time_utils.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/tag_widget.dart';

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
    final theme = Theme.of(context);
    final tags = [
      if (test.duration != null)
        TagWidget(icon: FontAwesomeIcons.clock, text: "${test.duration} min"),
      if (test.difficulty != null)
        TagWidget(
            icon: FontAwesomeIcons.turnUp, text: "level: ${test.difficulty}"),
      if (userAttempt.count != null)
        TagWidget(
            icon: FontAwesomeIcons.fileLines,
            text: "${userAttempt.count} attempts"),
    ];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
            color: isAttempted ? AppColors.success : Colors.transparent,
            width: 1),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRouter.modeTest, extra: {
            'test': test,
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and checkmark in a row for mobile
              Row(
                children: [
                  Expanded(
                    child: Text(
                      test.title ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isAttempted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAttempted
                            ? AppColors.success.withValues(alpha: 0.15)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Last time taken ${TimeUtils.timeAgo(test.updatedAt ?? test.createdAt!)}',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
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

  int getCountAttempt(Test test) {
    return test.userAttempt?.count ?? 0;
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/tag_widget.dart';
import 'package:toeic_desktop/ui/page/test/tests/widgets/test_last_studied_at_text.dart';

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
    final textTheme = context.textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.gray1.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRouter.modeTest, extra: {
            'test': test,
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      test.title ?? '',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isAttempted) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.checkDouble,
                            size: 10,
                            color: AppColors.success,
                          ),
                          if (userAttempt.count != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              "${userAttempt.count}",
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              if (isAttempted) ...[
                TestLastStudiedAtTimeText(
                  updatedAt: test.updatedAt,
                  createdAt: test.createdAt,
                ),
                const SizedBox(height: 12),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (test.duration != null)
                    TagWidget(
                        icon: FontAwesomeIcons.clock,
                        text: "${test.duration} ${S.current.min}"),
                  if (test.difficulty != null)
                    TagWidget(
                        icon: FontAwesomeIcons.layerGroup,
                        text: "${S.current.level}: ${test.difficulty}"),
                ],
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

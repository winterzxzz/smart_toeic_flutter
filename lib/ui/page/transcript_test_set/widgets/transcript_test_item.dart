import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test_set.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class TranscriptTestItem extends StatelessWidget {
  const TranscriptTestItem({
    super.key,
    required this.test,
  });

  final TranscriptTestSet test;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (test.id != null) {
            GoRouter.of(context).pushNamed(
              AppRouter.transcriptTestDetail,
              extra: {'transcriptTestId': test.id, 'title': test.title},
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7F0FF),
                  ),
                  child: test.image != null
                      ? Image.network(
                          '${AppConfigs.baseUrl.replaceAll('/api', '')}/uploads${test.image}',
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                          fit: BoxFit.contain,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.title ?? '',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.current.click_to_start_test,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

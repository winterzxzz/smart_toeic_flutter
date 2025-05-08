import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test_set.dart';

class TranscriptTestItem extends StatelessWidget {
  const TranscriptTestItem({
    super.key,
    required this.test,
  });

  final TranscriptTestSet test;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AppRouter.transcriptTestDetail,
            extra: {'transcriptTestId': test.id},
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7F0FF),
                    ),
                    child: Image.network(
                      '${AppConfigs.baseUrl.replaceAll('/api', '')}/uploads${test.image}',
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        test.title ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Click to start test',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

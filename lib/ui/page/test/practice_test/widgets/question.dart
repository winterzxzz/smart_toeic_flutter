import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_cached_image.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question_info_widget.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/test_audio_section.dart';

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
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.paragraph != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
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
          if (question.audio != null) ...[
            TestAudioSection(audioUrl: question.audio!),
          ],
          if (question.image != null) ...[
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(AppRouter.imageView, extra: {
                    'imageUrl': question.image!,
                  });
                },
                child: CustomCachedImage(
                  imageUrl: question.image!,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          QuestionInfoWidget(
            question: question,
          ),
        ],
      ),
    );
  }
}

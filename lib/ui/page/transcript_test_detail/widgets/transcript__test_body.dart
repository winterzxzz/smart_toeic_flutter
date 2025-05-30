import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/audio_section.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/check_result_display.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/transcript_test_input.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/transcript_test_navigation.dart';

class TranscriptTestBody extends StatelessWidget {
  const TranscriptTestBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  BlocBuilder<TranscriptTestDetailCubit,
                      TranscriptTestDetailState>(
                    builder: (context, state) {
                      final audioUrl = state.transcriptTests[state.currentIndex]
                                  .audioUrl !=
                              null
                          ? '${AppConfigs.baseUrl.replaceAll('/api', '')}/uploads${state.transcriptTests[state.currentIndex].audioUrl}'
                          : '';
                      return AudioSection(audioUrl: audioUrl);
                    },
                  ),
                  const SizedBox(height: 16),
                  const TranscriptTestInput(),
                  BlocSelector<TranscriptTestDetailCubit,
                      TranscriptTestDetailState, bool>(
                    selector: (state) {
                      return state.isCorrect;
                    },
                    builder: (context, isCorrect) {
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          const CheckResultDisplay(),
                          const SizedBox(height: 16),
                          if (isCorrect)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.circleCheck,
                                    color: AppColors.success),
                                const SizedBox(width: 8),
                                Text(
                                  S.current.correct,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        const TranscriptTestNavigation()
      ],
    );
  }
}

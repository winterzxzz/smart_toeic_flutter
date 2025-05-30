import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/audio_section.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/transcript_test_input.dart';

class TranscriptTestBody extends StatelessWidget {
  const TranscriptTestBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          BlocBuilder<TranscriptTestDetailCubit, TranscriptTestDetailState>(
            builder: (context, state) {
              final audioUrl = state
                          .transcriptTests[state.currentIndex].audioUrl !=
                      null
                  ? '${AppConfigs.baseUrl.replaceAll('/api', '')}/uploads${state.transcriptTests[state.currentIndex].audioUrl}'
                  : '';
              return AudioSection(audioUrl: audioUrl);
            },
          ),
          const SizedBox(height: 16),
          const Expanded(child: TranscriptTestInput()),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

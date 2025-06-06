import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/audio_section.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/transcript_test_input.dart';

class TranscriptTestBody extends StatelessWidget {
  const TranscriptTestBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              BlocBuilder<TranscriptTestDetailCubit, TranscriptTestDetailState>(
                buildWhen: (previous, current) {
                  return previous.currentIndex != current.currentIndex ||
                      previous.transcriptTests != current.transcriptTests;
                },
                builder: (context, state) {
                  final audioUrl = state
                              .transcriptTests[state.currentIndex].audioUrl !=
                          null
                      ? '${AppConfigs.baseUrl.replaceAll('/api', '')}/uploads${state.transcriptTests[state.currentIndex].audioUrl}'
                      : '';
                  return AudioSection(key: Key(audioUrl), audioUrl: audioUrl);
                },
              ),
              const SizedBox(height: 16),
              const Expanded(child: TranscriptTestInput()),
              const SizedBox(height: 32),
            ],
          ),
        ),
        BlocSelector<TranscriptTestDetailCubit, TranscriptTestDetailState,
            bool>(
          selector: (state) => state.isShowAiVoice,
          builder: (context, isShowAiVoice) {
            if (!isShowAiVoice) {
              return const SizedBox.shrink();
            } else {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: size.width,
                  height: size.height - 80,
                  child: Column(
                    children: [
                      const Spacer(),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Lottie.asset(AppImages.aiVoice,
                            fit: BoxFit.cover, repeat: true),
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

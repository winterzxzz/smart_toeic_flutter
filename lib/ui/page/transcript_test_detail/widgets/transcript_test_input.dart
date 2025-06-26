import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/check_result_display.dart';

class TranscriptTestInput extends StatefulWidget {
  const TranscriptTestInput({super.key});

  @override
  State<TranscriptTestInput> createState() => _TranscriptTestInputState();
}

class _TranscriptTestInputState extends State<TranscriptTestInput> {
  late final TextEditingController _transcriptController;
  late final TranscriptTestDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _transcriptController = TextEditingController();
    _cubit = context.read<TranscriptTestDetailCubit>();
  }

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<TranscriptTestDetailCubit, TranscriptTestDetailState,
        bool>(
      selector: (state) {
        return state.isCheck;
      },
      builder: (context, isCheck) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            BlocListener<TranscriptTestDetailCubit, TranscriptTestDetailState>(
              listenWhen: (previous, current) =>
                  previous.userInput != current.userInput,
              listener: (context, state) {
                if (state.userInput.isEmpty) {
                  _transcriptController.clear();
                } else {
                  _transcriptController.text = state.userInput;
                }
              },
              child: TextField(
                controller: _transcriptController,
                onChanged: (value) {
                  if (isCheck) {
                    _cubit.toggleIsCheck();
                  }
                },
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: S.current.type_what_you_hear,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.textGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const CheckResultDisplay(),
            const Spacer(),
            BlocListener<TranscriptTestDetailCubit, TranscriptTestDetailState>(
              listenWhen: (previous, current) =>
                  previous.isShowAiVoice != current.isShowAiVoice,
              listener: (context, state) {
                if (state.isShowAiVoice) {
                  AppNavigator(context: context).showAiVoiceOverlay(
                    onTap: () {
                      _cubit.toggleIsShowAiVoice();
                    },
                  );
                } else {
                  AppNavigator(context: context).hideAiVoiceOverlay();
                }
              },
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () {
                    _cubit.toggleIsShowAiVoice();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.microphoneLines),
                      const SizedBox(width: 8),
                      Text(S.current.practice_pronoun),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              width: double.infinity,
              height: 50,
              onPressed: () => _cubit.handleCheck(_transcriptController.text),
              child: Text(S.current.check),
            ),
          ],
        );
      },
    );
  }
}

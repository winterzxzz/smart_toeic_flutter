import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/speech_test.dart';

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
    return BlocSelector<TranscriptTestDetailCubit, TranscriptTestDetailState,
        bool>(
      selector: (state) {
        return state.isCheck;
      },
      builder: (context, isCheck) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocListener<TranscriptTestDetailCubit, TranscriptTestDetailState>(
              listenWhen: (previous, current) =>
                  previous.userInput != current.userInput,
              listener: (context, state) {
                if (state.userInput.isEmpty) {
                  _transcriptController.clear();
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
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.focusBorder),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 48,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () =>
                        _cubit.handleCheck(_transcriptController.text),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(S.current.check),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: 300,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                            child: SpeechTest(),
                          );
                        },
                      );
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
              ],
            ),
          ],
        );
      },
    );
  }
}

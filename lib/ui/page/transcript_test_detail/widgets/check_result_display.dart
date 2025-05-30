import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/transcript/check_result.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class CheckResultDisplay extends StatelessWidget {
  const CheckResultDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: BlocSelector<TranscriptTestDetailCubit,
              TranscriptTestDetailState, String>(
            selector: (state) {
              return state.userInput;
            },
            builder: (context, userInput) {
              return Text(
                '${S.current.you}: $userInput',
                style: theme.textTheme.bodyLarge,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              BlocBuilder<TranscriptTestDetailCubit, TranscriptTestDetailState>(
            buildWhen: (state, previous) =>
                state.checkResults != previous.checkResults ||
                state.isCheck != previous.isCheck,
            builder: (context, state) {
              if (!state.isCheck) {
                return Text('${S.current.result}: ',
                    style: theme.textTheme.bodyLarge);
              }

              List<TextSpan> spans = [
                TextSpan(
                  text: '${S.current.result}: ',
                  style: theme.textTheme.bodyLarge,
                ),
              ];

              for (int i = 0; i < state.checkResults.length; i++) {
                final result = state.checkResults[i];
                final color = switch (result.status) {
                  CheckResultStatus.correct => Colors.green,
                  CheckResultStatus.incorrect => Colors.red,
                  CheckResultStatus.next => Colors.grey,
                };

                if (i > 0) {
                  spans.add(const TextSpan(text: ' '));
                }

                spans.add(TextSpan(
                  text: result.word,
                  style: theme.textTheme.bodyLarge!.apply(color: color),
                ));
              }

              return RichText(
                text: TextSpan(children: spans),
              );
            },
          ),
        ),
      ],
    );
  }
}

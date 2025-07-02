import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class ProcessingIndicator extends StatelessWidget {
  const ProcessingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return BlocBuilder<TranscriptTestDetailCubit, TranscriptTestDetailState>(
      builder: (context, state) {
        final length = state.transcriptTests.length;
        return Row(
          children: List.generate(length, (index) {
            final marginRight = index == length - 1 ? 0.0 : 1.0;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: marginRight),
                color: (state.currentIndex - 1) >= index
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: .5),
                height: 5,
              ),
            );
          }),
        );
      },
    );
  }
}

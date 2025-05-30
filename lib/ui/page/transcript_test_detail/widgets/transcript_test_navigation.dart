import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class TranscriptTestNavigation extends StatefulWidget {
  const TranscriptTestNavigation({super.key});

  @override
  State<TranscriptTestNavigation> createState() =>
      _TranscriptTestNavigationState();
}

class _TranscriptTestNavigationState extends State<TranscriptTestNavigation> {
  late final TranscriptTestDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TranscriptTestDetailCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptTestDetailCubit, TranscriptTestDetailState>(
      buildWhen: (state, previous) =>
          state.currentIndex != previous.currentIndex ||
          state.transcriptTests.length != previous.transcriptTests.length,
      builder: (context, state) {
        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: state.currentIndex > 0
                        ? () {
                            _cubit.previousTranscriptTest();
                          }
                        : null,
                    icon: const FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      size: 20,
                    ),
                  ),
                  Text(
                    '${state.currentIndex + 1}/${state.transcriptTests.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed:
                        state.currentIndex < state.transcriptTests.length - 1
                            ? () {
                                _cubit.nextTranscriptTest();
                              }
                            : null,
                    icon: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: 20,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (state.currentIndex < state.transcriptTests.length - 1) {
                    _cubit.nextTranscriptTest();
                  } else {
                    GoRouter.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      state.currentIndex < state.transcriptTests.length - 1
                          ? S.current.next
                          : S.current.finish),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

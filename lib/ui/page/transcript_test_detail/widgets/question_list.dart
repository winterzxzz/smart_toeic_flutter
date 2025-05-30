import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({
    super.key,
  });

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  late final TranscriptTestDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TranscriptTestDetailCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  S.current.question_list,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<TranscriptTestDetailCubit,
                TranscriptTestDetailState>(
              buildWhen: (state, previous) =>
                  state.currentIndex != previous.currentIndex ||
                  state.transcriptTests != previous.transcriptTests,
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: state.transcriptTests.length,
                  itemBuilder: (context, index) {
                    final isCurrentQuestion = index == state.currentIndex;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      key: ValueKey('question-${index + 1}'),
                      leading: CircleAvatar(
                        backgroundColor: isCurrentQuestion
                            ? AppColors.primary
                            : theme.dividerColor,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCurrentQuestion ? Colors.white : null,
                          ),
                        ),
                      ),
                      title: Text(
                        '${S.current.question} ${index + 1}',
                        style: TextStyle(
                          fontWeight:
                              isCurrentQuestion ? FontWeight.bold : null,
                        ),
                      ),
                      onTap: () {
                        _cubit.goToTranscriptTest(index);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

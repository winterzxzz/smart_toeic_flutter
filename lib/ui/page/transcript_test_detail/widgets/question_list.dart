import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.question_list,
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child:
              BlocBuilder<TranscriptTestDetailCubit, TranscriptTestDetailState>(
            buildWhen: (state, previous) =>
                state.currentIndex != previous.currentIndex ||
                state.transcriptTests != previous.transcriptTests,
            builder: (context, state) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.transcriptTests.length,
                itemBuilder: (context, index) {
                  final isCurrentQuestion = index == state.currentIndex;
                  return ListTile(
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
                        fontWeight: isCurrentQuestion ? FontWeight.bold : null,
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
    );
  }
}

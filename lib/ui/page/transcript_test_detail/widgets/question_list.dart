import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';

class QuestionList extends StatelessWidget {
  const QuestionList({
    super.key,
    required this.transcriptTests,
    required this.currentIndex,
  });

  final List<TranscriptTest> transcriptTests;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question List',
                style: Theme.of(context).textTheme.titleMedium,
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
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: transcriptTests.length,
            itemBuilder: (context, index) {
              final isCurrentQuestion = index == currentIndex;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCurrentQuestion
                      ? AppColors.primary
                      : Theme.of(context).dividerColor,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrentQuestion ? Colors.white : null,
                    ),
                  ),
                ),
                title: Text(
                  'Question ${index + 1}',
                  style: TextStyle(
                    fontWeight: isCurrentQuestion ? FontWeight.bold : null,
                  ),
                ),
                onTap: () {
                  context
                      .read<TranscriptTestDetailCubit>()
                      .goToTranscriptTest(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

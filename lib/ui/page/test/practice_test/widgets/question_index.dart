import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/practice_test_part.dart';

class QuestionIndex extends StatefulWidget {
  const QuestionIndex({
    super.key,
  });

  @override
  State<QuestionIndex> createState() => _QuestionIndexState();
}

class _QuestionIndexState extends State<QuestionIndex> {
  late PracticeTestCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SafeArea(
        child: Container(
          color: theme.appBarTheme.backgroundColor,
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<PracticeTestCubit, PracticeTestState>(
            buildWhen: (previous, current) =>
                previous.parts != current.parts ||
                previous.questions != current.questions ||
                previous.testShow != current.testShow,
            builder: (context, state) {
              final partsWithQuestions = state.parts
                  .where((part) => state.questions
                      .any((question) => question.part == part.numValue))
                  .toList();
              return ListView.separated(
                itemCount: partsWithQuestions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final part = partsWithQuestions[index];
                  final questions = state.questions
                      .where((question) => question.part == part.numValue)
                      .toList();
                  return PracticeTestPart(
                    title: part.name,
                    questions: questions,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

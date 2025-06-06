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
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<PracticeTestCubit, PracticeTestState>(
            buildWhen: (previous, current) =>
                previous.parts != current.parts ||
                previous.questions != current.questions ||
                previous.testShow != current.testShow,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...state.parts.map(
                      (part) {
                        if (state.questions
                            .where((question) => question.part == part.numValue)
                            .isNotEmpty) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              PracticeTestPart(
                                title: part.name,
                                questions: state.questions
                                    .where((question) =>
                                        question.part == part.numValue)
                                    .toList(),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

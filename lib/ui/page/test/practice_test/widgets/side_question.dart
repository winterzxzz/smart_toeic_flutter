import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question.dart';

class SideQuestion extends StatefulWidget {
  const SideQuestion({
    super.key,
  });

  @override
  State<SideQuestion> createState() => _SideQuestionState();
}

class _SideQuestionState extends State<SideQuestion> {
  late final PracticeTestCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<PracticeTestCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
      ),
      child: BlocBuilder<PracticeTestCubit, PracticeTestState>(
        buildWhen: (previous, current) =>
            previous.questions != current.questions ||
            previous.focusPart != current.focusPart,
        builder: (context, state) {
          final questions = state.questions
              .where((q) => q.part == state.focusPart.numValue)
              .toList();
          return ScrollablePositionedList.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            scrollDirection: Axis.vertical,
            itemScrollController: _cubit.itemScrollController,
            itemPositionsListener: _cubit.itemPositionListener,
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return QuestionWidget(
                  key: Key(questions[index].id.toString()),
                  question: questions[index]);
            },
          );
        },
      ),
    );
  }
}

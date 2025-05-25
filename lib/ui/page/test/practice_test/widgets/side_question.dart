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
            itemCount: questions.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return BlocBuilder<PracticeTestCubit, PracticeTestState>(
                  buildWhen: (previous, current) {
                    return previous.parts != current.parts ||
                        previous.focusPart != current.focusPart;
                  },
                  builder: (context, state) {
                    return Container(
                      height: 38,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.parts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            _cubit.setFocusPart(state.parts[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: state.parts[index].numValue ==
                                      state.focusPart.numValue
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.backgroundDarkSub
                                      : AppColors.backgroundLightSub,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(state.parts[index].name,
                                style: TextStyle(
                                    color: state.parts[index].numValue ==
                                            state.focusPart.numValue
                                        ? Colors.white
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black)),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return QuestionWidget(question: questions[index - 1]);
            },
          );
        },
      ),
    );
  }
}

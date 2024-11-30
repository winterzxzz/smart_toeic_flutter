import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/heading_practice_test.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question_index.dart';

class PracticeTestPage extends StatefulWidget {
  const PracticeTestPage({
    super.key,
    required this.parts,
    required this.duration,
    required this.testId,
  });

  final List<PartEnum> parts;
  final Duration duration;
  final String testId;

  @override
  State<PracticeTestPage> createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends State<PracticeTestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<PracticeTestCubit>()
        ..initPracticeTest(widget.parts, widget.duration, widget.testId),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PracticeTestCubit, PracticeTestState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context).showLoadingOverlay();
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Column(
            children: [
              HeadingPracticeTest(),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(child: SideQuestion()),
                    const SizedBox(
                      width: 16,
                    ),
                    QuestionIndex(),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SideQuestion extends StatelessWidget {
  const SideQuestion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocSelector<PracticeTestCubit, PracticeTestState,
          List<QuestionModel>>(
        selector: (state) {
          return state.questionsOfPart;
        },
        builder: (context, questions) {
          return ScrollablePositionedList.builder(
            scrollDirection: Axis.vertical,
            itemScrollController:
                context.read<PracticeTestCubit>().itemScrollController,
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
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: state.parts
                            .map((part) => InkWell(
                                  onTap: () {
                                    context
                                        .read<PracticeTestCubit>()
                                        .setFocusPart(part);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: part.numValue ==
                                              state.focusPart.numValue
                                          ? AppColors.primary
                                          : Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(part.name,
                                        style: TextStyle(
                                            color: part.numValue ==
                                                    state.focusPart.numValue
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ))
                            .toList(),
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

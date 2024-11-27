import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/heading_practice_test.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question_index.dart';

class PracticeTestPage extends StatefulWidget {
  const PracticeTestPage(
      {super.key, required this.parts, required this.duration});

  final List<PartEnum> parts;
  final Duration duration;

  @override
  State<PracticeTestPage> createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends State<PracticeTestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<PracticeTestCubit>()
        ..initPracticeTest(widget.parts, widget.duration),
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 16,
            ),
            SideQuestion(),
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
    );
  }
}

class SideQuestion extends StatelessWidget {
  const SideQuestion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: context.read<PracticeTestCubit>().scrollController,
        child: Column(
          children: [
            HeadingPracticeTest(),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Select part
                  BlocBuilder<PracticeTestCubit, PracticeTestState>(
                    buildWhen: (previous, current) {
                      return previous.parts != current.parts ||
                          previous.focusPart != current.focusPart;
                    },
                    builder: (context, state) {
                      return Row(
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
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  BlocSelector<PracticeTestCubit, PracticeTestState,
                      List<Question>>(
                    selector: (state) {
                      return state.questionsOfPart;
                    },
                    builder: (context, questionsOfPart) {
                      return SelectionArea(
                        child: Column(
                          children: questionsOfPart
                              .map((question) => QuestionWidget(
                                    question: question,
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

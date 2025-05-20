import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
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
    required this.testShow,
    required this.parts,
    required this.duration,
    required this.testId,
    this.resultId,
  });

  final TestShow testShow;
  final List<PartEnum> parts;
  final Duration duration;
  final String testId;
  final String? resultId;

  @override
  State<PracticeTestPage> createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends State<PracticeTestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<PracticeTestCubit>()
        ..initPracticeTest(widget.testShow, widget.parts, widget.duration,
            widget.testId, widget.resultId),
      child: Page(testShow: widget.testShow),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.testShow,
  });

  final TestShow testShow;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocListener<PracticeTestCubit, PracticeTestState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context).showLoadingOverlay();
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
        }
      },
      child: PopScope(
        canPop: widget.testShow == TestShow.test ? false : true,
        child: Scaffold(
          body: Column(
            children: [
              const HeadingPracticeTest(),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile) const SizedBox(width: 16),
                    const Expanded(child: SideQuestion()),
                    if (!isMobile) ...[
                      const SizedBox(width: 16),
                      const QuestionIndex(),
                      const SizedBox(width: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isMobile
              ? BottomAppBar(
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocSelector<PracticeTestCubit, PracticeTestState, bool>(
                        selector: (state) {
                          return state.isShowQuestionIndex;
                        },
                        builder: (context, isShowQuestionIndex) {
                          return IconButton(
                            icon: Icon(
                              isShowQuestionIndex
                                  ? Icons.close
                                  : Icons.format_list_numbered,
                            ),
                            onPressed: () {
                              context
                                  .read<PracticeTestCubit>()
                                  .setIsShowQuestionIndex(!isShowQuestionIndex);
                            },
                          );
                        },
                      ),
                      if (widget.testShow == TestShow.test)
                        BlocBuilder<PracticeTestCubit, PracticeTestState>(
                          buildWhen: (previous, current) =>
                              previous.duration != current.duration,
                          builder: (context, state) {
                            return Text(
                              '${state.duration.inMinutes}:${state.duration.inSeconds % 60 < 10 ? '0' : ''}${state.duration.inSeconds % 60}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      if (widget.testShow == TestShow.test)
                        SizedBox(
                          width: 120,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Nộp bài'),
                                  content: const Text(
                                      'Bạn có chắc chắn muốn nộp bài không?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<PracticeTestCubit>()
                                            .submitTest(
                                                context,
                                                context
                                                    .read<PracticeTestCubit>()
                                                    .state
                                                    .duration);
                                      },
                                      child: const Text(
                                        'Nộp bài',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                            ),
                            child: const Text('Nộp bài'),
                          ),
                        ),
                    ],
                  ),
                )
              : null,
          floatingActionButton: isMobile
              ? BlocSelector<PracticeTestCubit, PracticeTestState, bool>(
                  selector: (state) {
                    return state.isShowQuestionIndex;
                  },
                  builder: (context, isShowQuestionIndex) {
                    if (isShowQuestionIndex) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const QuestionIndex(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
              : null,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
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
                      height: 38,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.parts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            context
                                .read<PracticeTestCubit>()
                                .setFocusPart(state.parts[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(right: 16),
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

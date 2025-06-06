import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/heading_practice_test.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question_index.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question.dart';

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
  late final PracticeTestCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<PracticeTestCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = AppNavigator(context: context);
    return BlocListener<PracticeTestCubit, PracticeTestState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          navigator.showLoadingOverlay(message: S.current.please_wait);
        } else {
          navigator.hideLoadingOverlay();
        }
      },
      child: BlocListener<PracticeTestCubit, PracticeTestState>(
        listenWhen: (previous, current) {
          return previous.loadStatusSubmit != current.loadStatusSubmit;
        },
        listener: (context, state) {
          if (state.loadStatusSubmit == LoadStatus.loading) {
            navigator.showLoadingOverlay(message: S.current.submitting);
          } else {
            navigator.hideLoadingOverlay();
            if (state.loadStatusSubmit == LoadStatus.success) {
              navigator.pushReplacementNamed(AppRouter.resultTest,
                  extra: {'resultModel': state.resultModel});
            } else {
              navigator.error(state.message);
            }
          }
        },
        child: PopScope(
          canPop: widget.testShow == TestShow.test ? false : true,
          child: SafeArea(
            child: Scaffold(
              endDrawer: const QuestionIndex(),
              body: BlocBuilder<PracticeTestCubit, PracticeTestState>(
                buildWhen: (previous, current) =>
                    previous.questions != current.questions ||
                    previous.focusPart != current.focusPart ||
                    previous.parts != current.parts,
                builder: (context, state) {
                  final questions = state.questions
                      .where((q) => q.part == state.focusPart.numValue)
                      .toList();

                  if (questions.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leading: LeadingBackButton(
                          isClose: true,
                          onPressed: () {
                            showConfirmDialog(
                              context,
                              S.current.exit,
                              S.current.are_you_sure_exit,
                              () {
                                GoRouter.of(context).pop();
                                GoRouter.of(context).pop();
                              },
                            );
                          },
                        ),
                        automaticallyImplyLeading: false,
                        toolbarHeight: 55,
                        floating: true,
                        title: const HeadingPracticeTest(),
                        actions: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                            ),
                          ),
                        ],
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _PartSelectorHeaderDelegate(
                          parts: state.parts,
                          focusPart: state.focusPart,
                          onTap: (part) => _cubit.setFocusPart(part),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return QuestionWidget(question: questions[index]);
                            },
                            childCount: questions.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              bottomNavigationBar: BottomAppBar(
                height: widget.testShow == TestShow.result ? 0 : null,
                child: widget.testShow == TestShow.result
                    ? null
                    : Row(children: [
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
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            onPressed: () {
                              showConfirmDialog(context, S.current.are_you_sure,
                                  S.current.are_you_sure_submit_test, () {
                                _cubit.submitTest();
                              });
                            },
                            child: Text(S.current.submit),
                          ),
                        ),
                      ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PartSelectorHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<PartEnum> parts;
  final PartEnum focusPart;
  final ValueChanged<PartEnum> onTap;

  _PartSelectorHeaderDelegate({
    required this.parts,
    required this.focusPart,
    required this.onTap,
  });

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Container(
      color: theme.appBarTheme.backgroundColor,
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 2, top: 2),
        itemCount: parts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) => InkWell(
          onTap: () => onTap(parts[index]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: parts[index].numValue == focusPart.numValue
                  ? theme.colorScheme.primary
                  : theme.brightness == Brightness.dark
                      ? AppColors.backgroundDarkSub
                      : AppColors.backgroundLightSub,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(parts[index].name,
                style: TextStyle(
                    color: parts[index].numValue == focusPart.numValue
                        ? Colors.white
                        : theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

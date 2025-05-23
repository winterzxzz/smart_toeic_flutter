import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/heading_practice_test.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question_index.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/side_question.dart';

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
          navigator.showLoadingOverlay(message: 'Please wait...');
        } else {
          navigator.hideLoadingOverlay();
        }
      },
      child: PopScope(
        canPop: widget.testShow == TestShow.test ? false : true,
        child: Scaffold(
          endDrawer: const QuestionIndex(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            title: const HeadingPracticeTest(),
          ),
          body: const SideQuestion(),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
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
                if (widget.testShow == TestShow.test) ...[
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showConfirmDialog(context, 'Are you sure?',
                              'Are you sure you want to submit the test?', () {
                            _cubit.submitTest(context, _cubit.state.duration);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

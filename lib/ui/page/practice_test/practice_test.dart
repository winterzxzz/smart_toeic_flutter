import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
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

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeTestCubit, PracticeTestState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Text(state.title,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Bạn có chắc chắn muốn thoát?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).pop();
                                      GoRouter.of(context).pop();
                                    },
                                    child: Text(
                                      'Thoát',
                                      style: TextStyle(
                                          color:
                                              AppColors.textFieldErrorBorder),
                                    )),
                                TextButton(
                                  onPressed: () {
                                    GoRouter.of(context).pop();
                                  },
                                  child: Text('Tiếp tục'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'Thoát',
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Select part
                            Row(
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
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(part.name,
                                              style: TextStyle(
                                                  color: part.numValue ==
                                                          state.focusPart
                                                              .numValue
                                                      ? Colors.white
                                                      : Colors.black)),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            SelectionArea(
                              child: Column(
                                children: state.questionsOfPart
                                    .map((question) => QuestionWidget(
                                          question: question,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      QuestionIndex(),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

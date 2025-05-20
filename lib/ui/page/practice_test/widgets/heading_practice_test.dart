import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';

class HeadingPracticeTest extends StatelessWidget {
  const HeadingPracticeTest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child:
                    BlocSelector<PracticeTestCubit, PracticeTestState, String>(
                  selector: (state) {
                    return state.title;
                  },
                  builder: (context, title) {
                    return Text(title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold));
                  },
                ),
              ),
              BlocSelector<PracticeTestCubit, PracticeTestState, TestShow>(
                selector: (state) {
                  return state.testShow;
                },
                builder: (context, state) {
                  final isShowResult = state == TestShow.result;
                  return TextButton(
                    onPressed: () {
                      if (isShowResult) {
                        GoRouter.of(context).pop();
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Bạn có chắc chắn muốn thoát?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  GoRouter.of(context).pop();
                                  GoRouter.of(context).pop();
                                },
                                child: const Text(
                                  'Thoát',
                                  style: TextStyle(
                                      color: AppColors.textFieldErrorBorder),
                                )),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              child: const Text('Tiếp tục'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Thoát',
                      style: TextStyle(
                          color: AppColors.error, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

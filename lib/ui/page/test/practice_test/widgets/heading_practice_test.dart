import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';

class HeadingPracticeTest extends StatelessWidget {
  const HeadingPracticeTest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PracticeTestCubit, PracticeTestState, String>(
      selector: (state) {
        return state.title;
      },
      builder: (context, title) {
        return Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
      },
    );
  }
}

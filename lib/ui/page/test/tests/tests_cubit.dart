import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/test/tests/tests_state.dart';

class TestsCubit extends Cubit<TestsState> {
  final TestRepository _testRepository;
  TestsCubit(this._testRepository) : super(TestsState.initial());

  Future<void> fetchTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _testRepository.getTests(limit: 10);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(title: l.message, type: ToastificationType.error);
      },
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        tests: r,
        filteredTests: r,
      )),
    );
  }

  void filterTests(String testType) {
    if (testType == TestType.all.name) {
      emit(state.copyWith(
        filteredTests: state.tests,
        selectedTestType: TestType.all,
      ));
    } else if (testType == TestType.exam.name) {
      emit(state.copyWith(
        filteredTests:
            state.tests.where((test) => test.type == "exam").toList(),
        selectedTestType: TestType.exam,
      ));
    } else if (testType == TestType.miniExam.name) {
      emit(state.copyWith(
        filteredTests:
            state.tests.where((test) => test.type == 'miniexam').toList(),
        selectedTestType: TestType.miniExam,
      ));
    }
  }

  void updateLastStudiedAt(String testId) {
    final newTests = state.tests.map((test) {
      if (test.id == testId) {
        return test.copyWith(updatedAt: DateTime.now());
      }
      return test;
    }).toList();

    final newFilteredTests = state.filteredTests.map((test) {
      if (test.id == testId) {
        return test.copyWith(updatedAt: DateTime.now());
      }
      return test;
    }).toList();

    emit(state.copyWith(
      tests: newTests,
      filteredTests: newFilteredTests,
    ));
  }
}

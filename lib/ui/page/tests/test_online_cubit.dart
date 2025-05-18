import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/page/tests/test_online_state.dart';

class DeThiOnlineCubit extends Cubit<DeThiOnlineState> {
  final TestRepository _testRepository;
  DeThiOnlineCubit(this._testRepository) : super(DeThiOnlineState.initial());

  Future<void> fetchTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _testRepository.getTests(limit: 10);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        tests: r,
        filteredTests: r,
      )),
    );
  }

  void filterTests(String testType) {
    if (isClosed) return;
    if (testType == TestType.all.name) {
      emit(state.copyWith(
        filteredTests: state.tests,
      ));
    } else if (testType == TestType.exam.name) {
      emit(state.copyWith(
        filteredTests:
            state.tests.where((test) => test.type == "exam").toList(),
      ));
    } else if (testType == TestType.miniExam.name) {
      emit(state.copyWith(
        filteredTests:
            state.tests.where((test) => test.type == 'miniexam').toList(),
      ));
    }
  }
}

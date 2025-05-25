import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/page/test/history_test/history_test_state.dart';

class HistoryTestCubit extends Cubit<HistoryTestState> {
  final TestRepository _testRepository;

  HistoryTestCubit(this._testRepository) : super(HistoryTestState.initial());

  Future<void> getResultTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await _testRepository.getResultTests(limit: 10);
    result.fold(
      (error) => emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: error.errors?.first.message)),
      (results) => emit(
          state.copyWith(loadStatus: LoadStatus.success, results: results)),
    );
  }
}

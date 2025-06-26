import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/test/history_test/history_test_state.dart';

class HistoryTestCubit extends Cubit<HistoryTestState> {
  final TestRepository _testRepository;

  HistoryTestCubit(this._testRepository) : super(HistoryTestState.initial());

  Future<void> getResultTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await _testRepository.getResultTests(limit: 10);
    result.fold(
      (l) {
        emit(
            state.copyWith(loadStatus: LoadStatus.failure, message: l.message));
        showToast(title: l.message, type: ToastificationType.error);
      },
      (results) => emit(
          state.copyWith(loadStatus: LoadStatus.success, results: results)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_state.dart';

class DeThiOnlineCubit extends Cubit<DeThiOnlineState> {
  final TestRepository _testRepository;
  DeThiOnlineCubit(this._testRepository) : super(DeThiOnlineState.initial());

  Future<void> fetchTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _testRepository.getTests();
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        tests: r,
      )),
    );
  }
}

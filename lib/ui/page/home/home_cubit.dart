import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/page/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TestRepository _testRepository;
  HomeCubit(this._testRepository) : super(HomeState.initial());

  void init() async {
    final cookie = SharedPreferencesHelper().getCookies();
    if (isClosed) return;
    await Future.microtask(
        () => emit(state.copyWith(loadStatus: LoadStatus.loading)));
    if (cookie == null) {
      await _getPublicTests();
      return;
    }
    await getData();
  }

  Future<void> getData() async {
    final response = await _testRepository.getTestByUser();
    response.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: l.toString())),
        (r) => emit(state.copyWith(
            tests: r.tests,
            resultTests: r.results.take(3).toList(),
            loadStatus: LoadStatus.success)));
  }

  Future<void> _getPublicTests() async {
    final response = await _testRepository.getPublicTests();
    response.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: l.toString())),
        (r) => emit(state.copyWith(tests: r, loadStatus: LoadStatus.success)));
  }

  void reset() {
    emit(HomeState.initial());
  }
}

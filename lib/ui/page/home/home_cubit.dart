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
    if (cookie == null) return;
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    await Future.wait([_getTests(), _getResultTests()]);
  }

  Future<void> _getTests() async {
    final response = await _testRepository.getTests();
    response.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: l.toString())),
        (r) => emit(state.copyWith(tests: r, loadStatus: LoadStatus.success)));
  }

  Future<void> _getResultTests() async {
    final response = await _testRepository.getResultTests();
    response.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: l.toString())),
        (r) => emit(state.copyWith(
            resultTests: r.take(3).toList(), loadStatus: LoadStatus.success)));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/page/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final ProfileRepository profileRepo;

  SplashCubit(this.profileRepo) : super(SplashState.initial());

  Future<void> getUser() async {
    final isLogin = SharedPreferencesHelper().getCookies() != null;
    if (!isLogin) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(loadStatus: LoadStatus.failure));
      return;
    }
    final result = await profileRepo.getUser();
    result.fold(
        (error) => emit(state.copyWith(
            loadStatus: LoadStatus.failure,
            message: error.errors?.first.message ??
                'Unexpected error occurred')), (response) {
      injector<UserCubit>().updateUser(response);
      emit(state.copyWith(loadStatus: LoadStatus.success));
    });
  }
}

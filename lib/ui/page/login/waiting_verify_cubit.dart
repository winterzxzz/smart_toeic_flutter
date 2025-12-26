import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/page/login/waiting_verify_state.dart';

class WaitingVerifyCubit extends Cubit<WaitingVerifyState> {
  final ProfileRepository profileRepository;
  Timer? _timer;

  WaitingVerifyCubit(this.profileRepository)
      : super(const WaitingVerifyState());

  void startPolling() {
    // Prevent multiple timers
    stopPolling();

    emit(state.copyWith(loadStatus: LoadStatus.loading));

    // Poll every 4 seconds as requested
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      await _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    final result = await profileRepository.getUser();
    result.fold(
      (failure) {
        // If it fails, we keep polling.
        // Can optionally handle specific error codes here.
      },
      (user) {
        // Success! User is verified.
        stopPolling();
        injector<UserCubit>().updateUser(user);
        emit(state.copyWith(loadStatus: LoadStatus.success));
      },
    );
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}

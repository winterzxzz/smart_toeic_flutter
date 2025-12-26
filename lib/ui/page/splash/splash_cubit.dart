import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/utils/biometric_helper.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final ProfileRepository profileRepo;

  SplashCubit(this.profileRepo) : super(SplashState.initial());

  Future<void> checkAuthStatus() async {
    final hasCookies = await SecureStorageHelper.instance.getCookies() != null;

    if (!hasCookies) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(loadStatus: LoadStatus.failure));
      return;
    }

    // Check if biometric is enabled
    final biometricEnabled =
        await SecureStorageHelper.instance.getBiometricEnabled();
    final canUseBiometric = await BiometricHelper.instance.canCheckBiometrics();

    if (biometricEnabled && canUseBiometric) {
      // Require biometric authentication first
      emit(state.copyWith(requiresBiometric: true));
    } else {
      // No biometric, just verify token with backend
      await _verifyWithBackend();
    }
  }

  Future<void> authenticateWithBiometric() async {
    final result = await BiometricHelper.instance.authenticate();

    switch (result) {
      case BiometricResult.success:
        await _verifyWithBackend();
        break;
      case BiometricResult.failed:
      case BiometricResult.lockedOut:
      case BiometricResult.error:
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          requiresBiometric: false,
        ));
        break;
      case BiometricResult.notAvailable:
      case BiometricResult.notEnrolled:
        // Biometric not available, try backend verification anyway
        await _verifyWithBackend();
        break;
    }
  }

  Future<void> _verifyWithBackend() async {
    final result = await profileRepo.getUser();
    result.fold((l) {
      emit(state.copyWith(loadStatus: LoadStatus.failure, message: l.message));
      showToast(title: l.message, type: ToastificationType.error);
    }, (response) {
      injector<UserCubit>().updateUser(response);
      emit(state.copyWith(loadStatus: LoadStatus.success));
    });
  }

  // Keep the old method for backward compatibility
  Future<void> getUser() async {
    await checkAuthStatus();
  }
}

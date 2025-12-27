import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/verify_otp/verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthRepository authRepo;

  VerifyOtpCubit(this.authRepo) : super(const VerifyOtpState());

  /// Called when the OTP page is opened
  /// This sends the OTP to user's email
  Future<void> requestOtp(String key, String email) async {
    emit(state.copyWith(
      requestOtpStatus: LoadStatus.loading,
      key: key,
      email: email,
    ));
    try {
      final result = await authRepo.requestVerifyOtp(key, email);
      result.fold(
        (error) {
          emit(state.copyWith(
            requestOtpStatus: LoadStatus.failure,
            message: error.message,
          ));
        },
        (response) {
          emit(state.copyWith(
            requestOtpStatus: LoadStatus.success,
            key: response.key,
            email: response.email,
          ));
          showToast(
            title: S.current.send_email_success,
            type: ToastificationType.success,
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        requestOtpStatus: LoadStatus.failure,
        message: e.toString(),
      ));
      showToast(
        title: e.toString(),
        type: ToastificationType.error,
      );
    }
  }

  /// Called when user submits the OTP code
  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(verifyOtpStatus: LoadStatus.loading));
    try {
      if (otp.isEmpty) {
        throw S.current.please_enter_all_information;
      }

      final result = await authRepo.verifyOtp(otp, state.email);
      result.fold(
        (error) {
          emit(state.copyWith(
            verifyOtpStatus: LoadStatus.failure,
            message: error.message,
          ));
          showToast(
            title: error.message,
            type: ToastificationType.error,
          );
        },
        (authSuccess) {
          // Save token and update user
          SecureStorageHelper.instance.saveToken(authSuccess.accessToken);
          injector<UserCubit>().updateUser(authSuccess.user);

          emit(state.copyWith(
            verifyOtpStatus: LoadStatus.success,
            message: S.current.success,
          ));
          showToast(
            title: S.current.success,
            type: ToastificationType.success,
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        verifyOtpStatus: LoadStatus.failure,
        message: e.toString(),
      ));
      showToast(
        title: e.toString(),
        type: ToastificationType.error,
      );
    }
  }
}

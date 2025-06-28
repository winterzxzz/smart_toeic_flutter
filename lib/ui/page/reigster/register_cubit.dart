import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/common/utils/app_validartor.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/reigster/register_state.dart';

import '../../../data/models/enums/load_status.dart';
import '../../../data/network/repositories/auth_repository.dart';
import '../../../language/generated/l10n.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepo;

  RegisterCubit(this.authRepo) : super(const RegisterState());

  Future<void> register(String email, String name, String password) async {
    emit(state.copyWith(loadDataStatus: LoadStatus.initial));
    try {
      if (!AppValidator.validateEmpty(email)) {
        throw (S.current.empty_email_error);
      }
      if (!AppValidator.validateEmpty(password)) {
        throw (S.current.empty_password_error);
      }
      if (!AppValidator.validateEmpty(name)) {
        throw (S.current.empty_email_error);
      }
      if (!AppValidator.validateEmail(email)) {
        throw (S.current.invalid_email_error);
      }
      if (!AppValidator.validateLength(password, 6, 30)) {
        throw (S.current.password_length_error);
      }
      if (!AppValidator.validatePassword(password)) {
        throw (S.current.invalid_password_error);
      }
      if (!AppValidator.validateLength(password, 6, 30)) {
        throw (S.current.confirm_password_length_error);
      }
      emit(state.copyWith(loadDataStatus: LoadStatus.loading));
      final result =
          await authRepo.signUp(email: email, name: name, password: password);
      result.fold((l) {
        emit(state.copyWith(
            loadDataStatus: LoadStatus.failure, message: l.message));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      }, (response) {
        emit(state.copyWith(
            loadDataStatus: LoadStatus.success,
            message: S.current.register_success_login_to_continue));
        showToast(
          title: S.current.register_success_login_to_continue,
          type: ToastificationType.success,
        );
      });
    } catch (e) {
      emit(state.copyWith(
          loadDataStatus: LoadStatus.failure, message: e.toString()));
      // Show error message
      showToast(
        title: e.toString(),
        type: ToastificationType.error,
      );
    }
  }
}

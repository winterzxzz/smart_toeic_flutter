import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/utils/app_validartor.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/page/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepo;

  LoginCubit(this.authRepo) : super(LoginState.initial());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loadStatus: LoadStatus.initial));
    try {
      if (!AppValidator.validateEmpty(email)) {
        throw (S.current.empty_email_error);
      }
      if (!AppValidator.validateEmpty(password)) {
        throw (S.current.empty_password_error);
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
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      final result = await authRepo.login(email, password);
      result.fold(
          (l) => emit(state.copyWith(
              loadStatus: LoadStatus.failure, errorMessage: l.message)),
          (response) {
        injector<UserCubit>().updateUser(response);
        emit(state.copyWith(loadStatus: LoadStatus.success));
      });
    } catch (e) {
      // clear errormessage before
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, errorMessage: e.toString()));
    }
  }
}

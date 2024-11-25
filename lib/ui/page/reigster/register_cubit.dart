import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/utils/app_validartor.dart';
import 'package:toeic_desktop/ui/page/reigster/register_state.dart';

import '../../../data/models/enums/load_status.dart';
import '../../../data/network/repositories/auth_repository.dart';
import '../../../language/generated/l10n.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepo;

  RegisterCubit(this.authRepo) : super(const RegisterState());

  Future<void> register(String email, String name, String password) async {
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
      result.fold(
          (error) => emit(state.copyWith(
              loadDataStatus: LoadStatus.failure,
              message: error.message)), (response) {
        injector<UserCubit>().setUser(response!);
        emit(state.copyWith(loadDataStatus: LoadStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
          loadDataStatus: LoadStatus.failure, message: e.toString()));
    }
  }
}

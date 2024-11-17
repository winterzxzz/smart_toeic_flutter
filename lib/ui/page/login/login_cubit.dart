import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/page/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  void loginWithUsernameAndPassword(String username, String password) {}

  void loginWithGoogle() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {} catch (e) {
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, errorMessage: e.toString()));
    }
  }

  void loginWithFacebook() {}
}

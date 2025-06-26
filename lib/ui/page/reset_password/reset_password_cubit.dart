import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository authRepository;
  ResetPasswordCubit(this.authRepository) : super(ResetPasswordState.initial());

  void resetPassword(String email) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final rs = await authRepository.resetPassword(email);
    rs.fold((l) {
      emit(state.copyWith(loadStatus: LoadStatus.failure, message: l.message));
      showToast(title: l.message, type: ToastificationType.error);
    }, (r) {
      emit(state.copyWith(
          loadStatus: LoadStatus.success,
          message: r.message,
          status: r.status == 1));
      showToast(title: r.message ?? 'Send Email Success!', type: ToastificationType.error);
    });
  }
}

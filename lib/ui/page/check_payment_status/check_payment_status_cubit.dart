import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/payment_repository.dart';
import 'package:toeic_desktop/data/services/noti_service.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_state.dart';

class CheckPaymentStatusCubit extends Cubit<CheckPaymentStatusState> {
  final PaymentRepository paymentRepository;

  CheckPaymentStatusCubit(this.paymentRepository)
      : super(const CheckPaymentStatusState.initial());

  Future<void> checkPaymentStatus(String transId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await paymentRepository.checkPaymentStatus(transId);
    result.fold((l) {
      emit(state.copyWith(loadStatus: LoadStatus.failure, message: l.message));
      showToast(title: l.message, type: ToastificationType.error);
      injector<NotiService>().showFlutterNotification(
        title: S.current.update_error,
        content: l.message,
      );
    }, (r) {
      emit(state.copyWith(
          loadStatus: LoadStatus.success, message: r.payment.returnMessage));
      injector<NotiService>().showFlutterNotification(
        title: S.current.congratulations,
        content: S.current.your_account_has_been_successfully_upgraded,
      );
      injector<UserCubit>().updateUser(r.user);
    });
  }
}

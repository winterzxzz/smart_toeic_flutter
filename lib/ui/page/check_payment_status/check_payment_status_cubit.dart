import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/payment_repository.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_state.dart';

class CheckPaymentStatusCubit extends Cubit<CheckPaymentStatusState> {
  final PaymentRepository paymentRepository;

  CheckPaymentStatusCubit(this.paymentRepository)
      : super(CheckPaymentStatusState.initial());

  Future<void> checkPaymentStatus(String transId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await paymentRepository.checkPaymentStatus(transId);
    result.fold(
        (l) => emit(
            state.copyWith(loadStatus: LoadStatus.failure, message: l.errors?.first.message)),
        (r) {
      emit(state.copyWith(
          loadStatus: LoadStatus.success, message: r.payment.returnMessage));
      injector<UserCubit>().updateUser(r.user);
    });
  }
}

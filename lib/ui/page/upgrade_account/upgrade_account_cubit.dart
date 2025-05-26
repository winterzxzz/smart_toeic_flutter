import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/payment_repository.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_state.dart';

class UpgradeAccountCubit extends Cubit<UpgradeAccountState> {
  final PaymentRepository _paymentRepository;

  UpgradeAccountCubit(this._paymentRepository)
      : super(UpgradeAccountState.initial());

  Future<void> upgradeAccount() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await _paymentRepository.getPayment();
    result.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.message,
      )),
      (payment) => emit(
          state.copyWith(payment: payment, loadStatus: LoadStatus.success)),
    );
  }
}

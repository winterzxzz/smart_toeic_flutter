import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/payment_repository.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_state.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeAccountCubit extends Cubit<UpgradeAccountState> {
  final PaymentRepository _paymentRepository;

  UpgradeAccountCubit(this._paymentRepository)
      : super(UpgradeAccountState.initial());

  Future<void> upgradeAccount() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await _paymentRepository.getPayment();
    result.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (payment) {
        emit(state.copyWith(payment: payment, loadStatus: LoadStatus.success));
        if (state.payment != null) {
          _launchUrl(state.payment!.orderUrl);
        }
      },
    );
  }

  void mailTo() {
    _launchUrl(
        'mailto:${AppConfigs.mailTo}?subject=Support&body=${S.current.support_body}');
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      showToast(
        title: S.current.could_not_open_url,
        type: ToastificationType.error,
      );
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/common/utils/app_validartor.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/services/web3_service.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/certificates/certificates_state.dart';

class CertificatesCubit extends Cubit<CertificatesState> {
  final Web3Service web3Service;

  CertificatesCubit({required this.web3Service})
      : super(CertificatesState.initial());

  Future<void> getCertificates({
    required String searchQuery,
  }) async {
    try {
      if (!AppValidator.validateEmpty(searchQuery)) {
        throw Exception(S.current.please_enter_national_id);
      }

      if (!AppValidator.validateLength(searchQuery, 8, 12)) {
        throw Exception(S.current.national_id_invalid);
      }

      emit(state.copyWith(
        loadStatus: LoadStatus.loading,
        searchQuery: searchQuery,
      ));
      final certificates = await web3Service.getCertificatesByNationalId(
        nationalId: searchQuery,
      );
      emit(state.copyWith(
        loadStatus: LoadStatus.success,
        certificates: certificates,
      ));
    } catch (e) {
      // remove Exception: from the error message
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      showToast(title: errorMessage, type: ToastificationType.error);
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        errorMessage: errorMessage,
      ));
    }
  }
}

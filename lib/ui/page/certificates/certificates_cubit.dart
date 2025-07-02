import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/services/web3_service.dart';
import 'package:toeic_desktop/ui/page/certificates/certificates_state.dart';

class CertificatesCubit extends Cubit<CertificatesState> {
  final Web3Service web3Service;

  CertificatesCubit({required this.web3Service})
      : super(CertificatesState.initial());

  Future<void> getCertificates({
    required String searchQuery,
  }) async {
    emit(state.copyWith(
      loadStatus: LoadStatus.loading,
      searchQuery: searchQuery,
    ));
    try {
      final certificates = await web3Service.getCertificatesByNationalId(
        nationalId: searchQuery,
      );
      emit(state.copyWith(
        loadStatus: LoadStatus.success,
        certificates: certificates,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

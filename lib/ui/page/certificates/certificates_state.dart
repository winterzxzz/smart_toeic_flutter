import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/ui_models/certificate.dart';

class CertificatesState extends Equatable {
  final LoadStatus loadStatus;
  final List<Certificate> certificates;
  final String errorMessage;
  final String searchQuery;

  const CertificatesState({
    required this.loadStatus,
    required this.certificates,
    required this.errorMessage,
    required this.searchQuery,
  });

  // initial state
  factory CertificatesState.initial() => const CertificatesState(
        loadStatus: LoadStatus.initial,
        certificates: [],
        errorMessage: '',
        searchQuery: '',
      );

  // copy with
  CertificatesState copyWith({
    LoadStatus? loadStatus,
    List<Certificate>? certificates,
    String? errorMessage,
    String? searchQuery,
  }) =>
      CertificatesState(
        loadStatus: loadStatus ?? this.loadStatus,
        certificates: certificates ?? this.certificates,
        errorMessage: errorMessage ?? this.errorMessage,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object?> get props =>
      [loadStatus, certificates, errorMessage, searchQuery];
}

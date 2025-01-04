import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class ResetPasswordState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final bool status;

  const ResetPasswordState({
    required this.loadStatus,
    required this.message,
    required this.status,
  });

  // initial state
  factory ResetPasswordState.initial() {
    return const ResetPasswordState(
      loadStatus: LoadStatus.initial,
      message: '',
      status: false,
    );
  }

  ResetPasswordState copyWith({
    LoadStatus? loadStatus,
    String? message,
    bool? status,
  }) {
    return ResetPasswordState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message, status];
}

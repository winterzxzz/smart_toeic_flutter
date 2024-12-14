import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class CheckPaymentStatusState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  

  const CheckPaymentStatusState({
    required this.loadStatus,
    required this.message,
  });

  const CheckPaymentStatusState.initial()
      : loadStatus = LoadStatus.initial,
        message = '';

  CheckPaymentStatusState copyWith({
    LoadStatus? loadStatus,
    String? message,
  }) {
    return CheckPaymentStatusState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message];
}

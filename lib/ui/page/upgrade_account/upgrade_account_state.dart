import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/payment/payment.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class UpgradeAccountState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final Payment? payment;

  const UpgradeAccountState({
    required this.loadStatus,
    required this.message,
    this.payment,
  });

  // initial state
  factory UpgradeAccountState.initial() {
    return const UpgradeAccountState(
      loadStatus: LoadStatus.initial,
      message: '',
    );
  }

  UpgradeAccountState copyWith({
    LoadStatus? loadStatus,
    String? message,
    Payment? payment,
  }) {
    return UpgradeAccountState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      payment: payment ?? this.payment,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message, payment];
}

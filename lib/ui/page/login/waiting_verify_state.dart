import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class WaitingVerifyState extends Equatable {
  final LoadStatus loadStatus;
  final String? message;

  const WaitingVerifyState({
    this.loadStatus = LoadStatus.initial,
    this.message,
  });

  WaitingVerifyState copyWith({
    LoadStatus? loadStatus,
    String? message,
  }) {
    return WaitingVerifyState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message];
}

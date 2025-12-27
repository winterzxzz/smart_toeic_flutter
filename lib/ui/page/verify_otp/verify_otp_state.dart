import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class VerifyOtpState extends Equatable {
  final LoadStatus requestOtpStatus;
  final LoadStatus verifyOtpStatus;
  final String message;
  final String key;
  final String email;

  const VerifyOtpState({
    this.requestOtpStatus = LoadStatus.initial,
    this.verifyOtpStatus = LoadStatus.initial,
    this.message = "",
    this.key = "",
    this.email = "",
  });

  @override
  List<Object?> get props =>
      [requestOtpStatus, verifyOtpStatus, message, key, email];

  VerifyOtpState copyWith({
    LoadStatus? requestOtpStatus,
    LoadStatus? verifyOtpStatus,
    String? message,
    String? key,
    String? email,
  }) {
    return VerifyOtpState(
      requestOtpStatus: requestOtpStatus ?? this.requestOtpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      message: message ?? this.message,
      key: key ?? this.key,
      email: email ?? this.email,
    );
  }
}

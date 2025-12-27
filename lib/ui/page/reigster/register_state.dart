import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class RegisterState extends Equatable {
  final LoadStatus loadDataStatus;
  final String message;
  final String? verificationKey;
  final String? email;

  const RegisterState({
    this.loadDataStatus = LoadStatus.initial,
    this.message = "",
    this.verificationKey,
    this.email,
  });

  @override
  List<Object?> get props => [loadDataStatus, verificationKey, email];

  RegisterState copyWith({
    LoadStatus? loadDataStatus,
    String? message,
    String? verificationKey,
    String? email,
  }) {
    return RegisterState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
      message: message ?? this.message,
      verificationKey: verificationKey ?? this.verificationKey,
      email: email ?? this.email,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class RegisterState extends Equatable {
  final LoadStatus loadDataStatus;
  final String message;

  const RegisterState(
      {this.loadDataStatus = LoadStatus.initial, this.message = ""});

  @override
  List<Object?> get props => [
        loadDataStatus,
      ];

  RegisterState copyWith({LoadStatus? loadDataStatus, String? message}) {
    return RegisterState(
        loadDataStatus: loadDataStatus ?? this.loadDataStatus,
        message: message ?? this.message);
  }
}

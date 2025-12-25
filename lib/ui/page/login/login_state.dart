import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/entities/auth/auth_response.dart';

class LoginState extends Equatable {
  final LoadStatus loadStatus;
  final String errorMessage;

  final AuthResponse? authChallenge;

  const LoginState({
    required this.loadStatus,
    required this.errorMessage,
    this.authChallenge,
  });

  // initial state
  factory LoginState.initial() {
    return const LoginState(loadStatus: LoadStatus.initial, errorMessage: '');
  }

  LoginState copyWith({
    LoadStatus? loadStatus,
    String? errorMessage,
    AuthResponse? authChallenge,
  }) {
    return LoginState(
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      authChallenge: authChallenge ?? this.authChallenge,
    );
  }

  @override
  List<Object?> get props => [loadStatus, errorMessage, authChallenge];
}

import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class SplashState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final bool requiresBiometric;

  const SplashState({
    required this.loadStatus,
    required this.message,
    this.requiresBiometric = false,
  });

  // initial state
  factory SplashState.initial() => const SplashState(
        loadStatus: LoadStatus.initial,
        message: '',
        requiresBiometric: false,
      );

  SplashState copyWith({
    LoadStatus? loadStatus,
    String? message,
    bool? requiresBiometric,
  }) =>
      SplashState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        requiresBiometric: requiresBiometric ?? this.requiresBiometric,
      );

  @override
  List<Object?> get props => [loadStatus, message, requiresBiometric];
}

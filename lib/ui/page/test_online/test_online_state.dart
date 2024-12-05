import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class DeThiOnlineState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<Test> tests;

  const DeThiOnlineState({
    required this.loadStatus,
    required this.message,
    required this.tests,
  });

  // initstate
  factory DeThiOnlineState.initial() => const DeThiOnlineState(
        loadStatus: LoadStatus.initial,
        message: '',
        tests: [],
      );

  // copyWith
  DeThiOnlineState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<Test>? tests,
  }) =>
      DeThiOnlineState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        tests: tests ?? this.tests,
      );

  @override
  List<Object?> get props => [loadStatus, tests];
}

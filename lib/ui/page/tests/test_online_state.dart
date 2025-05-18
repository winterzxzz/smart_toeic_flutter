import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class DeThiOnlineState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<Test> tests;
  final List<Test> filteredTests;

  const DeThiOnlineState({
    required this.loadStatus,
    required this.message,
    required this.tests,
    required this.filteredTests,
  });

  // initstate
  factory DeThiOnlineState.initial() => const DeThiOnlineState(
        loadStatus: LoadStatus.initial,
        message: '',
        tests: [],
        filteredTests: [],
      );

  // copyWith
  DeThiOnlineState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<Test>? tests,
    List<Test>? filteredTests,
  }) =>
      DeThiOnlineState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        tests: tests ?? this.tests,
        filteredTests: filteredTests ?? this.filteredTests,
      );

  @override
  List<Object?> get props => [loadStatus, tests, filteredTests];
}

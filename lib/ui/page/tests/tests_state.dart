import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';

class TestsState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final TestType selectedTestType;
  final List<Test> tests;
  final List<Test> filteredTests;

  const TestsState({
    required this.loadStatus,
    required this.message,
    required this.selectedTestType,
    required this.tests,
    required this.filteredTests,
  });

  // initstate
  factory TestsState.initial() => const TestsState(
        loadStatus: LoadStatus.initial,
        message: '',
        selectedTestType: TestType.all,
        tests: [],
        filteredTests: [],
      );

  // copyWith
  TestsState copyWith({
    LoadStatus? loadStatus,
    String? message,
    TestType? selectedTestType,
    List<Test>? tests,
    List<Test>? filteredTests,
  }) =>
      TestsState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        selectedTestType: selectedTestType ?? this.selectedTestType,
        tests: tests ?? this.tests,
        filteredTests: filteredTests ?? this.filteredTests,
      );

  @override
  List<Object?> get props =>
      [loadStatus, tests, filteredTests, selectedTestType];
}

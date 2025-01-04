import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class HistoryTestState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<ResultTest> results;

  const HistoryTestState({
    required this.loadStatus,
    required this.message,
    required this.results,
  });

  // initial state
  factory HistoryTestState.initial() {
    return const HistoryTestState(
      loadStatus: LoadStatus.initial,
      message: '',
      results: [],
    );
  }

  // copyWith
  HistoryTestState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<ResultTest>? results,
  }) {
    return HistoryTestState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message, results];
}

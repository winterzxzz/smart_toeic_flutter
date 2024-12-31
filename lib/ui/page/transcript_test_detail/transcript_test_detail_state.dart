

import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class TranscriptTestDetailState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<TranscriptTest> transcriptTests;
  final int currentIndex;

  const TranscriptTestDetailState({
    required this.loadStatus,
    required this.message,
    required this.transcriptTests,
    required this.currentIndex,
  });

  // initstate
  factory TranscriptTestDetailState.initial() {
    return const TranscriptTestDetailState(
      loadStatus: LoadStatus.initial,
      message: '',
      transcriptTests: [],
      currentIndex: 0,
    );
  }

  // copyWith 
  TranscriptTestDetailState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<TranscriptTest>? transcriptTests,
    int? currentIndex,
  }) {
    return TranscriptTestDetailState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      transcriptTests: transcriptTests ?? this.transcriptTests,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message, transcriptTests, currentIndex];
}
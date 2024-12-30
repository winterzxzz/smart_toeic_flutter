import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class ListenCopyState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<TranscriptTest> transcriptTests;

  const ListenCopyState({
    required this.loadStatus,
    required this.message,
    required this.transcriptTests,
  });

  // init state
  factory ListenCopyState.initial() {
    return const ListenCopyState(
      loadStatus: LoadStatus.initial,
      message: '',
      transcriptTests: [],
    );
  }

  // copy with
  ListenCopyState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<TranscriptTest>? transcriptTests,
  }) {
    return ListenCopyState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      transcriptTests: transcriptTests ?? this.transcriptTests,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message, transcriptTests];
}

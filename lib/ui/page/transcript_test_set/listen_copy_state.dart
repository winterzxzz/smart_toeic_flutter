import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test_set.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class ListenCopyState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<TranscriptTestSet> transcriptTestSets;
  final List<TranscriptTestSet> filteredTranscriptTestSets;
  final bool isFilterOpen;
  final List<String> filterParts;

  const ListenCopyState({
    required this.loadStatus,
    required this.message,
    required this.transcriptTestSets,
    required this.filteredTranscriptTestSets,
    required this.isFilterOpen,
    required this.filterParts,
  });

  // init state
  factory ListenCopyState.initial() {
    return const ListenCopyState(
      loadStatus: LoadStatus.initial,
      message: '',
      transcriptTestSets: [],
      filteredTranscriptTestSets: [],
      isFilterOpen: false,
      filterParts: [],
    );
  }

  // copy with
  ListenCopyState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<TranscriptTestSet>? transcriptTestSets,
    List<TranscriptTestSet>? filteredTranscriptTestSets,
    bool? isFilterOpen,
    List<String>? filterParts,
  }) {
    return ListenCopyState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      transcriptTestSets: transcriptTestSets ?? this.transcriptTestSets,
      filteredTranscriptTestSets: filteredTranscriptTestSets ?? this.filteredTranscriptTestSets,
      isFilterOpen: isFilterOpen ?? this.isFilterOpen,
      filterParts: filterParts ?? this.filterParts,
    );
  }

  @override
  List<Object?> get props => [loadStatus, message, transcriptTestSets, filteredTranscriptTestSets, isFilterOpen, filterParts];
}

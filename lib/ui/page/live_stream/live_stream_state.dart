import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class LiveStreamState extends Equatable {
  final LoadStatus loadStatus;
  final String currentTranscription;
  final List<String> transcriptionHistory;

  const LiveStreamState({
    required this.loadStatus,
    required this.currentTranscription,
    required this.transcriptionHistory,
  });

  // initial state
  factory LiveStreamState.initial() {
    return const LiveStreamState(
      loadStatus: LoadStatus.initial,
      currentTranscription: '',
      transcriptionHistory: [],
    );
  }
  
  // copy with
  LiveStreamState copyWith({
    LoadStatus? loadStatus,
    String? currentTranscription,
    List<String>? transcriptionHistory,
  }) {
    return LiveStreamState(
      loadStatus: loadStatus ?? this.loadStatus,
      currentTranscription: currentTranscription ?? this.currentTranscription,
      transcriptionHistory: transcriptionHistory ?? this.transcriptionHistory,
    );
  }

  @override
  List<Object?> get props => [loadStatus, currentTranscription, transcriptionHistory];
}

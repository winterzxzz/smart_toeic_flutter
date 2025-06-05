import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/transcript/check_result.dart';

class TranscriptTestDetailState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<TranscriptTest> transcriptTests;
  final int currentIndex;
  final bool isCheck;
  final List<CheckResult> checkResults;
  final bool isCorrect;
  final String userInput;
  final bool isShowAiVoice;

  const TranscriptTestDetailState({
    required this.loadStatus,
    required this.message,
    required this.transcriptTests,
    required this.currentIndex,
    required this.isCheck,
    required this.checkResults,
    required this.isCorrect,
    required this.userInput,
    required this.isShowAiVoice,
  });

  // initstate
  factory TranscriptTestDetailState.initial() {
    return const TranscriptTestDetailState(
      loadStatus: LoadStatus.initial,
      message: '',
      transcriptTests: [],
      currentIndex: 0,
      isCheck: false,
      checkResults: [],
      isCorrect: false,
      userInput: '',
      isShowAiVoice: false,
    );
  }

  // copyWith
  TranscriptTestDetailState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<TranscriptTest>? transcriptTests,
    int? currentIndex,
    bool? isCheck,
    List<CheckResult>? checkResults,
    bool? isCorrect,
    String? userInput,
    bool? isShowAiVoice,
  }) {
    return TranscriptTestDetailState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      transcriptTests: transcriptTests ?? this.transcriptTests,
      currentIndex: currentIndex ?? this.currentIndex,
      isCheck: isCheck ?? this.isCheck,
      checkResults: checkResults ?? this.checkResults,
      isCorrect: isCorrect ?? this.isCorrect,
      userInput: userInput ?? this.userInput,
      isShowAiVoice: isShowAiVoice ?? this.isShowAiVoice,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        message,
        transcriptTests,
        currentIndex,
        isCheck,
        checkResults,
        isCorrect,
        userInput,
        isShowAiVoice,
      ];
}

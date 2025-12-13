import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';

class FlashCardQuizzState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final int currentIndex;
  final int typeQuizzIndex;
  final List<FlashCardLearning> flashCardLearning;
  final List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequest;
  final bool isAnimating;
  final bool isCorrect;
  final bool isFinish;
  const FlashCardQuizzState({
    required this.loadStatus,
    required this.message,
    required this.flashCardLearning,
    required this.currentIndex,
    required this.typeQuizzIndex,
    required this.flashCardQuizzScoreRequest,
    required this.isAnimating,
    required this.isCorrect,
    required this.isFinish,
  });

  factory FlashCardQuizzState.initial() => const FlashCardQuizzState(
        loadStatus: LoadStatus.initial,
        message: '',
        flashCardLearning: [],
        flashCardQuizzScoreRequest: [],
        currentIndex: 0,
        typeQuizzIndex: 1,
        isAnimating: false,
        isCorrect: false,
        isFinish: false,
      );

  FlashCardQuizzState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<FlashCardLearning>? flashCardLearning,
    int? currentIndex,
    int? typeQuizzIndex,
    List<FlashCardQuizzScoreRequest>? flashCardQuizzScoreRequest,
    bool? isAnimating,
    bool? isCorrect,
    bool? isFinish,
  }) =>
      FlashCardQuizzState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        flashCardLearning: flashCardLearning ?? this.flashCardLearning,
        flashCardQuizzScoreRequest:
            flashCardQuizzScoreRequest ?? this.flashCardQuizzScoreRequest,
        currentIndex: currentIndex ?? this.currentIndex,
        typeQuizzIndex: typeQuizzIndex ?? this.typeQuizzIndex,
        isAnimating: isAnimating ?? this.isAnimating,
        isCorrect: isCorrect ?? this.isCorrect,
        isFinish: isFinish ?? this.isFinish,
      );

  @override
  List<Object> get props => [
        loadStatus,
        message,
        flashCardLearning,
        flashCardQuizzScoreRequest,
        currentIndex,
        typeQuizzIndex,
        isAnimating,
        isCorrect,
        isFinish,
      ];
}

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
  

  const FlashCardQuizzState({
    required this.loadStatus,
    required this.message,
    required this.flashCardLearning,
    required this.currentIndex,
    required this.typeQuizzIndex,
    required this.flashCardQuizzScoreRequest,
  });

  factory FlashCardQuizzState.initial() => FlashCardQuizzState(
        loadStatus: LoadStatus.initial,
        message: '',
        flashCardLearning: [],
        flashCardQuizzScoreRequest: [],
        currentIndex: 0,
        typeQuizzIndex: 0,
      );

  FlashCardQuizzState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<FlashCardLearning>? flashCardLearning,
    int? currentIndex,
    int? typeQuizzIndex,
    List<FlashCardQuizzScoreRequest>? flashCardQuizzScoreRequest,
  }) =>
      FlashCardQuizzState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        flashCardLearning: flashCardLearning ?? this.flashCardLearning,
        flashCardQuizzScoreRequest:
            flashCardQuizzScoreRequest ?? this.flashCardQuizzScoreRequest,
        currentIndex: currentIndex ?? this.currentIndex,
        typeQuizzIndex: typeQuizzIndex ?? this.typeQuizzIndex,
      );

  @override
  List<Object> get props => [
        loadStatus,
        message,
        flashCardLearning,
        flashCardQuizzScoreRequest,
        currentIndex,
        typeQuizzIndex,
      ];
}

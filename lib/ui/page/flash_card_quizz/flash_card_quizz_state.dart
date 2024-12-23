import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardQuizzState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final int currentIndex;
  final int typeQuizzIndex;
  final List<FlashCardLearning> flashCardLearning;

  const FlashCardQuizzState({
    required this.loadStatus,
    required this.message,
    required this.flashCardLearning,
    required this.currentIndex,
    required this.typeQuizzIndex,
  });

  factory FlashCardQuizzState.initial() => FlashCardQuizzState(
        loadStatus: LoadStatus.initial,
        message: '',
        flashCardLearning: [],
          currentIndex: 0,
        typeQuizzIndex: 0,
      );

  FlashCardQuizzState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<FlashCardLearning>? flashCardLearning,
    int? currentIndex,
    int? typeQuizzIndex,
  }) =>
      FlashCardQuizzState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        flashCardLearning: flashCardLearning ?? this.flashCardLearning,
        currentIndex: currentIndex ?? this.currentIndex,
        typeQuizzIndex: typeQuizzIndex ?? this.typeQuizzIndex,
      );

  @override
  List<Object> get props => [
        loadStatus,
        message,
        flashCardLearning,
        currentIndex,
        typeQuizzIndex
      ];
}

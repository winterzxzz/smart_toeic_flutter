import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_ai_gen.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardDetailLearningState extends Equatable {
  final LoadStatus loadStatus;
  final LoadStatus loadStatusAiGen;
  final String message;
  final List<FlashCardLearning> flashCards;
  final FlashCardAiGen? flashCardAiGen;

  const FlashCardDetailLearningState({
    required this.loadStatus,
    required this.loadStatusAiGen,
    required this.message,
    required this.flashCards,
    this.flashCardAiGen,
  });

  // initstate
  factory FlashCardDetailLearningState.initial() =>
      const FlashCardDetailLearningState(
        loadStatus: LoadStatus.initial,
        loadStatusAiGen: LoadStatus.initial,
        message: '',
        flashCards: [],
        flashCardAiGen: null,
      );

  // copyWith
  FlashCardDetailLearningState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? loadStatusAiGen,
    String? message,
    List<FlashCardLearning>? flashCards,
    FlashCardAiGen? flashCardAiGen,
  }) =>
      FlashCardDetailLearningState(
        loadStatus: loadStatus ?? this.loadStatus,
        loadStatusAiGen: loadStatusAiGen ?? this.loadStatusAiGen,
        message: message ?? this.message,
        flashCards: flashCards ?? this.flashCards,
        flashCardAiGen: flashCardAiGen ?? this.flashCardAiGen,
      );

  @override
  List<Object?> get props =>
      [loadStatus, flashCards, flashCardAiGen, loadStatusAiGen];
}

import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardState extends Equatable {
  final LoadStatus loadStatus;
  final LoadStatus loadStatusLearning;
  final String message;
  final List<SetFlashCard> flashCards;
  final List<SetFlashCardLearning> flashCardsLearning;

  const FlashCardState({
    required this.loadStatus,
    required this.loadStatusLearning,
    required this.message,
    required this.flashCards,
    required this.flashCardsLearning,
  });

  // initstate
  factory FlashCardState.initial() => const FlashCardState(
        loadStatus: LoadStatus.initial,
        loadStatusLearning: LoadStatus.initial,
        message: '',
        flashCards: [],
        flashCardsLearning: [],
      );

  // copyWith
  FlashCardState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? loadStatusLearning,
    String? message,
    List<SetFlashCard>? flashCards,
    List<SetFlashCardLearning>? flashCardsLearning,
  }) =>
      FlashCardState(
        loadStatus: loadStatus ?? this.loadStatus,
        loadStatusLearning: loadStatusLearning ?? this.loadStatusLearning,
        message: message ?? this.message,
        flashCards: flashCards ?? this.flashCards,
        flashCardsLearning: flashCardsLearning ?? this.flashCardsLearning,
      );

  @override
  List<Object?> get props =>
      [loadStatus, loadStatusLearning, flashCards, flashCardsLearning];
}

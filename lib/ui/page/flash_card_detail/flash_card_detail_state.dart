import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardDetailState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<FlashCard> flashCards;

  const FlashCardDetailState({
    required this.loadStatus,
    required this.message,
    required this.flashCards,
  });

  // initstate
  factory FlashCardDetailState.initial() => const FlashCardDetailState(
        loadStatus: LoadStatus.initial,
        message: '',
        flashCards: [],
      );

  // copyWith
  FlashCardDetailState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<FlashCard>? flashCards,
  }) =>
      FlashCardDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        flashCards: flashCards ?? this.flashCards,
      );

  @override
  List<Object?> get props => [loadStatus, flashCards];
}

import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<SetFlashCard> flashCards;

  const FlashCardState({
    required this.loadStatus,
    required this.message,
    required this.flashCards,
  });

  // initstate
  factory FlashCardState.initial() => const FlashCardState(
        loadStatus: LoadStatus.initial,
        message: '',
        flashCards: [],
      );

  // copyWith
  FlashCardState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<SetFlashCard>? flashCards,
  }) =>
      FlashCardState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        flashCards: flashCards ?? this.flashCards,
      );

  @override
  List<Object?> get props => [loadStatus, flashCards];
}

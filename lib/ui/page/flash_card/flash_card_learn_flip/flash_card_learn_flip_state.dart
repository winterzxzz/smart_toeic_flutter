import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';

class FlashCardLearnFlipState extends Equatable {
  final String title;
  final List<FlashCard> flashCards;
  final int currentIndex;
  final bool isFlipped;

  const FlashCardLearnFlipState(
      {required this.title,
      required this.flashCards,
      required this.currentIndex,
      required this.isFlipped});

  // inittial state

  factory FlashCardLearnFlipState.initial() {
    return const FlashCardLearnFlipState(
      title: '',
      flashCards: [],
      currentIndex: 0,
      isFlipped: false,
    );
  }

  // copy with
  FlashCardLearnFlipState copyWith({
    String? title,
    List<FlashCard>? flashCards,
    int? currentIndex,
    bool? isFlipped,
  }) {
    return FlashCardLearnFlipState(
      title: title ?? this.title,
      flashCards: flashCards ?? this.flashCards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }

  @override
  List<Object?> get props => [title, flashCards, currentIndex, isFlipped];
}

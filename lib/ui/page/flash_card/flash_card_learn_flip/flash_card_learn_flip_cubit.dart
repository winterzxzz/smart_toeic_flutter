import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/flash_card_learn_flip_state.dart';

class FlashCardLearnFlipCubit extends Cubit<FlashCardLearnFlipState> {
  FlashCardLearnFlipCubit() : super(FlashCardLearnFlipState.initial()) {
    controller = FlipCardController();
  }

  late FlipCardController controller;

  void init(List<FlashCard> flashCards, String title) {
    emit(state.copyWith(flashCards: flashCards, title: title));
  }

  void nextCard() async {
    if (state.isFlipped) {
      await controller.flipcard().then((_) {
        if (state.currentIndex < state.flashCards.length - 1) {
          emit(state.copyWith(
              currentIndex: state.currentIndex + 1, isFlipped: false));
        }
      });
    } else {
      if (state.currentIndex < state.flashCards.length - 1) {
        emit(state.copyWith(
            currentIndex: state.currentIndex + 1, isFlipped: false));
      }
    }
  }

  void previousCard() async {
    if (state.isFlipped) {
      await controller.flipcard().then((_) {
        if (state.currentIndex > 0) {
          emit(state.copyWith(
              currentIndex: state.currentIndex - 1, isFlipped: false));
        }
      });
    } else {
      if (state.currentIndex > 0) {
        emit(state.copyWith(
            currentIndex: state.currentIndex - 1, isFlipped: false));
      }
    }
  }

  void flipCard() async {
    await controller.flipcard().then((_) {
      emit(state.copyWith(isFlipped: !state.isFlipped));
    });
  }
}

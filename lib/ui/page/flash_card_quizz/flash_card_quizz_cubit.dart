import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quiz_request.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizzCubit extends Cubit<FlashCardQuizzState> {
  final FlashCardRespository _flashCardRepository;
  FlashCardQuizzCubit(this._flashCardRepository)
      : super(FlashCardQuizzState.initial());

  void fetchFlashCardQuizzs(List<FlashCard> flashCards) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _flashCardRepository
        .getFlashCardQuizz(FlashCardQuizRequest(prompt: flashCards));
    response.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: l.toString())),
        (r) => emit(state.copyWith(
            loadStatus: LoadStatus.success, flashCardQuizzs: r)));
  }

  void nextQuestion() {
    if (state.currentIndex == state.flashCardQuizzs.length - 1) {
      return;
    }
    emit(state.copyWith(currentIndex: state.currentIndex + 1));
  }

  void previousQuestion() {
    if (state.currentIndex == 0) {
      return;
    }
    emit(state.copyWith(currentIndex: state.currentIndex - 1));
  }


  void selectOption(String id, String option) {
    emit(state.copyWith(selectedOption: {...state.selectedOption, id: option}));
  }

  Future<void> finishQuizz(BuildContext context) async {
    int correctAnswers = 0;
    for (var element in state.flashCardQuizzs) {
      log('${element.flashcardId} - ${element.quiz.correctAnswer} ');
      log('${state.selectedOption[element.flashcardId]}');
      if (state.selectedOption[element.flashcardId] == element.quiz.correctAnswer) {
        correctAnswers++;
      }
    }
    GoRouter.of(context).pushReplacement(AppRouter.flashCardQuizzResult, extra: {
      'correctAnswers': correctAnswers,
      'totalQuestions': state.flashCardQuizzs.length,
    });
  }
}

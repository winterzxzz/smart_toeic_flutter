import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizzCubit extends Cubit<FlashCardQuizzState> {
  final FlashCardRespository _flashCardRepository;
  // this is time for do all quizz
  late Timer _timerStartQuizz;
  late Duration currentTime;
  // this is time for next quizz
  late Timer _timerNextQuizz;
  FlashCardQuizzCubit(this._flashCardRepository)
      : super(FlashCardQuizzState.initial()) {
    currentTime = Duration.zero;
    _startTimer();
  }

  void _startTimer() {
    _timerStartQuizz = Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime = currentTime + Duration(seconds: 1);
    });
  }

  void resetNextTimer() {
    _timerNextQuizz.cancel();
    _timerNextQuizz = Timer(const Duration(seconds: 3), () {
      next();
    });
  }

  void init(String newLearningSetId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final rs =
        await _flashCardRepository.updateFlashCardLearning(newLearningSetId);
    rs.fold(
        (l1) => emit(state.copyWith(
            loadStatus: LoadStatus.failure,
            message: l1.errors?.first.message)), (r1) async {
      final rs2 = await _flashCardRepository.getFlashCardsLearning(r1.id!);
      rs2.fold(
          (l2) => emit(state.copyWith(
              loadStatus: LoadStatus.failure,
              message: l2.errors?.first.message)),
          (r2) => emit(state.copyWith(
              loadStatus: LoadStatus.success,
              flashCardLearning: r2,
              flashCardQuizzScoreRequest: r2
                  .map((e) => FlashCardQuizzScoreRequest(
                        id: e.flashcardId?.id,
                        word: e.flashcardId?.word,
                        numOfQuiz: 6,
                        isChangeDifficulty: true,
                      ))
                  .toList())));
    });
  }

  void nextTypeQuizz() {
    emit(state.copyWith(
        typeQuizzIndex: state.typeQuizzIndex + 1, currentIndex: 0));
  }

  void next() {
    if (state.typeQuizzIndex == 1) {
      nextTypeQuizz();
      return;
    } else {
      if (state.currentIndex == state.flashCardLearning.length - 1 &&
          state.typeQuizzIndex == 6) {
        return;
      } else {
        if (state.currentIndex < state.flashCardLearning.length - 1 &&
            state.typeQuizzIndex <= 6) {
          emit(state.copyWith(currentIndex: state.currentIndex + 1));
        } else {
          nextTypeQuizz();
        }
      }
    }
  }

  void updateConfidenceLevel(double confidenceLevel, String id) {
    emit(state.copyWith(
        flashCardQuizzScoreRequest: state.flashCardQuizzScoreRequest.map((e) {
      if (e.id == id) {
        return e.copyWith(difficultRate: confidenceLevel);
      }
      return e;
    }).toList()));
    next();
  }

  void answer(String word, bool isCorrect) {
    emit(state.copyWith(
        flashCardQuizzScoreRequest: state.flashCardQuizzScoreRequest.map((e) {
      if (e.word == word) {
        final newPercentage = (isCorrect
                ? e.accuracy! + (1 / e.numOfQuiz!)
                : e.accuracy! - (1 / e.numOfQuiz!))
            .toStringAsFixed(2);
        if (isCorrect) {
          return e.copyWith(accuracy: double.parse(newPercentage));
        } else {
          return e.copyWith(accuracy: double.parse(newPercentage));
        }
      }
      return e;
    }).toList()));
  }

  void finish() {
    final numberOfQuiz = state.flashCardQuizzScoreRequest.length * 5 + 1;
    final timeMinutes = currentTime.inMinutes / numberOfQuiz;
    emit(state.copyWith(
        flashCardQuizzScoreRequest: state.flashCardQuizzScoreRequest
            .map((e) => e.copyWith(
                  timeMinutes: timeMinutes,
                ))
            .toList()));
  }
}

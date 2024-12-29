import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizzCubit extends Cubit<FlashCardQuizzState> {
  final FlashCardRespository _flashCardRepository;
  // this is time for do all quizz
  late Duration currentTime;
  FlashCardQuizzCubit(this._flashCardRepository)
      : super(FlashCardQuizzState.initial()) {
    currentTime = Duration.zero;
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime = currentTime + Duration(seconds: 1);
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
                        id: e.id,
                        word: e.flashcardId?.word,
                        numOfQuiz: 0,
                        isChangeDifficulty: true,
                      ))
                  .toList())));
    });
  }

  void nextTypeQuizz() {
    emit(state.copyWith(
      typeQuizzIndex: state.typeQuizzIndex + 1,
      currentIndex: 0,
    ));
  }

  void next() {
    emit(state.copyWith(isAnimating: false, isCorrect: false));
    if (state.typeQuizzIndex == 1) {
      nextTypeQuizz();
      return;
    } else {
      if (state.currentIndex == state.flashCardLearning.length - 1 &&
          state.typeQuizzIndex == 6) {
        finish();
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
    triggerAnimation(true);
  }

  void answer(String word, bool isCorrect, {bool isTrigger = true}) {
    emit(state.copyWith(
        flashCardQuizzScoreRequest: state.flashCardQuizzScoreRequest.map((e) {
      if (e.word == word) {
        return e.copyWith(
          numOfCorrect: isCorrect ? (e.numOfCorrect ?? 0) + 1 : e.numOfCorrect,
          numOfQuiz: (e.numOfQuiz ?? 0) + 1,
        );
      }
      return e;
    }).toList()));
    if (isTrigger) {
      triggerAnimation(isCorrect);
    }
  }

  void finish() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final numberOfQuiz = state.flashCardQuizzScoreRequest
            .map((e) => e.numOfQuiz)
            .reduce((a, b) => a! + b!) ??
        1;
    final timeMinutes = currentTime.inMinutes / numberOfQuiz;
    final newFlashCardQuizzScoreRequest = state.flashCardQuizzScoreRequest
        .map((e) => e.copyWith(
              timeMinutes: double.parse(timeMinutes.toStringAsFixed(2)),
              accuracy: double.parse(
                  ((e.numOfCorrect ?? 0) / (e.numOfQuiz ?? 1))
                      .toStringAsFixed(2)),
            ))
        .toList();
    final rs = await _flashCardRepository
        .updateSessionScore(newFlashCardQuizzScoreRequest);
    rs.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: l.errors?.first.message)),
        (r) => emit(state.copyWith(
              isFinish: true,
              flashCardQuizzScoreRequest: newFlashCardQuizzScoreRequest,
              loadStatus: LoadStatus.success,
              message: 'Kết thúc bài kiểm tra',
            )));
  }

  void triggerAnimation(bool isCorrect) {
    emit(state.copyWith(isAnimating: true, isCorrect: isCorrect));
    // Reset animation flag after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      if (state.isAnimating) {
        next();
      }
    });
  }
}

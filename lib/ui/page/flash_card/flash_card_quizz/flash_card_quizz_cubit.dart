import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizzCubit extends Cubit<FlashCardQuizzState> {
  final FlashCardRespository _flashCardRepository;
  // this is time for do all quizz
  late Duration currentTime;
  Timer? _animationTimer;
  // Add field to track question times
  final Map<String, Duration> _questionTimes = {};
  DateTime? _questionStartTime;

  FlashCardQuizzCubit(this._flashCardRepository)
      : super(FlashCardQuizzState.initial()) {
    currentTime = Duration.zero;
    _startTimer();
    _questionStartTime = DateTime.now();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime = currentTime + const Duration(seconds: 1);
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
    _animationTimer?.cancel();
    emit(state.copyWith(isAnimating: false, isCorrect: false));

    // Record start time for the next question
    _questionStartTime = DateTime.now();

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
    triggerAnimation(true, isShowAnimation: false);
  }

  void answer(String word, bool isCorrect, {bool isTrigger = true}) {
    // Calculate time spent on this question
    if (_questionStartTime != null) {
      final timeSpent = DateTime.now().difference(_questionStartTime!);
      _questionTimes[word] =
          (_questionTimes[word] ?? Duration.zero) + timeSpent;
    }

    // Get the time spent in minutes for this word
    final timeSpentMinutes = _questionTimes[word]?.inSeconds ?? 0 / 60.0;

    emit(state.copyWith(
        flashCardQuizzScoreRequest: state.flashCardQuizzScoreRequest.map((e) {
      if (e.word == word) {
        return e.copyWith(
          numOfCorrect: isCorrect ? (e.numOfCorrect ?? 0) + 1 : e.numOfCorrect,
          numOfQuiz: (e.numOfQuiz ?? 0) + 1,
          timeMinutes: double.parse(timeSpentMinutes.toStringAsFixed(6)),
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

  void triggerAnimation(bool isCorrect, {bool isShowAnimation = true}) {
    if (isShowAnimation) {
      emit(state.copyWith(isAnimating: true, isCorrect: isCorrect));
    }
    if (isShowAnimation) {
      _animationTimer?.cancel();
      _animationTimer = Timer(const Duration(seconds: 3), () {
        if (state.isAnimating) {
          next();
        }
      });
    } else {
      _animationTimer?.cancel();
      _animationTimer = Timer(const Duration(seconds: 2), () {
        next();
      });
    }
  }

  // Add method to get time spent for a specific word
  Duration getTimeSpentForWord(String word) {
    return _questionTimes[word] ?? Duration.zero;
  }

  // Add method to get formatted time for display
  String getFormattedTimeForWord(String word) {
    final duration = getTimeSpentForWord(word);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

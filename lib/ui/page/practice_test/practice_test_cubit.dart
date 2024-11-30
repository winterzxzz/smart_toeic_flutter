import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';

class PracticeTestCubit extends Cubit<PracticeTestState> {
  final TestRepository _testRepository;

  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionListener;

  PracticeTestCubit(this._testRepository) : super(PracticeTestState.initial()) {
    itemScrollController = ItemScrollController();
    itemPositionListener = ItemPositionsListener.create();
  }

  Future<void> _scrollToQuestion(int index) async {
    await itemScrollController.scrollTo(
      index: index + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  void setUrlAudio(String url) async {
    await audioPlayer.setSourceUrl(url).then((_) async {
      await audioPlayer.resume();
    });
  }

  Future<void> getPracticeTestDetail(
      String testId, List<PartEnum> parts) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _testRepository.getDetailTest(testId);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
      )),
      (questions) => emit(state.copyWith(
        questions: _setQuestionFollowPartSelected(questions, parts),
        loadStatus: LoadStatus.success,
        questionsOfPart: _setQuestionFollowPartSelected(questions, parts)
            .where((question) => question.part == state.focusPart.numValue)
            .toList(),
      )),
    );
  }

  void initPracticeTest(
      List<PartEnum> parts, Duration duration, String testId) async {
    emit(state.copyWith(
        parts: parts,
        duration: duration,
        focusPart: parts.first,
        testId: testId));
    await getPracticeTestDetail(testId, parts);
  }

  List<QuestionModel> _setQuestionFollowPartSelected(
      List<QuestionModel> questions, List<PartEnum> parts) {
    List<QuestionModel> listQuestion = [];
    for (var part in parts) {
      listQuestion.addAll(questions
          .where((question) => question.part == part.numValue)
          .toList());
    }
    return listQuestion;
  }

  void setFocusQuestion(QuestionModel question) {
    final partOfQuestion = question.part;
    final questionsOfPart = state.questions
        .where((question) => question.part == partOfQuestion)
        .toList();
    _scrollToQuestion(questionsOfPart.indexOf(question));
    if (partOfQuestion == state.focusPart.numValue) {
      emit(state.copyWith(
        focusQuestion: question.id,
        questionsOfPart: questionsOfPart,
      ));
    } else {
      emit(state.copyWith(
        focusQuestion: question.id,
        questionsOfPart: questionsOfPart,
        focusPart: partOfQuestion.partValue,
      ));
    }
  }

  void setFocusPart(PartEnum part) {
    final questionsOfPart = state.questions
        .where((question) => question.part == part.numValue)
        .toList();
    if (questionsOfPart.isEmpty) {
      emit(state.copyWith(
        focusPart: part,
      ));
    } else {
      emit(state.copyWith(
        focusPart: part,
        focusQuestion: questionsOfPart.first.id,
        questionsOfPart: questionsOfPart,
      ));
    }
  }

  void setUserAnswer(QuestionModel question, String userAnswer) {
    final newQuestions = state.questions.map((q) {
      if (q.id == question.id) {
        return question.copyWith(userAnswer: userAnswer);
      }
      return q;
    }).toList();
    final newQuestionsOfPart = newQuestions
        .where((question) => question.part == state.focusPart.numValue)
        .toList();
    emit(state.copyWith(
      questions: newQuestions,
      questionsOfPart: newQuestionsOfPart,
    ));
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}

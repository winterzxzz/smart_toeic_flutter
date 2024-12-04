import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/request/result_item_request.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
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

  void initPracticeTest(List<PartEnum> parts, Duration duration, String testId,
      {List<QuestionModel>? questions}) async {
    if (questions != null) {
      emit(state.copyWith(
          parts: parts,
          duration: duration,
          focusPart: parts.first,
          testId: testId,
          isShowAnswer: true,
          questions: questions));
    } else {
      emit(state.copyWith(
          parts: parts,
          duration: duration,
          focusPart: parts.first,
          testId: testId));
      await getPracticeTestDetail(testId, parts);
    }
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

  void submitTest(BuildContext context, Duration remainingTime) async {
    AppNavigator(context: context).showLoadingOverlay();
    final totalQuestions = state.questions.length;
    final answerdQuestions = state.questions
        .where((question) => question.userAnswer != null)
        .toList();
    final totalAnswerdQuestions = answerdQuestions.length;
    final totalCorrectQuestions = answerdQuestions
        .where((question) => question.correctAnswer == question.userAnswer)
        .toList()
        .length;
    final incorrectQuestions = totalAnswerdQuestions - totalCorrectQuestions;
    final notAnswerQuestions = totalQuestions - totalAnswerdQuestions;

    final listeningScore = totalCorrectQuestions * 10;
    final readingScore = totalCorrectQuestions * 10;
    final overallScore = listeningScore + readingScore;
    final totalDurationDoIt = state.duration - remainingTime;

    final resultModel = ResultModel(
      testName: state.title,
      totalQuestion: totalQuestions,
      correctQuestion: totalCorrectQuestions,
      incorrectQuestion: incorrectQuestions,
      notAnswerQuestion: notAnswerQuestions,
      overallScore: overallScore,
      listeningScore: listeningScore,
      readingScore: readingScore,
      duration: totalDurationDoIt,
      questions: state.questions,
    );

    ResultTestRequest request = ResultTestRequest(
      rs: Rs(
        testId: state.testId,
        numberOfQuestions: totalQuestions,
        secondTime: totalDurationDoIt.inSeconds,
      ),
      rsis: answerdQuestions
          .map((question) => Rsi(
                useranswer: question.userAnswer!,
                correctanswer: question.correctAnswer,
                questionNum: question.id.toString(),
                rsiPart: question.part,
              ))
          .toList(),
    );

    final response = await _testRepository.submitTest(request);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
      )),
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
      )),
    );
    if (context.mounted) {
      AppNavigator(context: context).hideLoadingOverlay();
      AppNavigator(context: context).success('Submit test success');
      GoRouter.of(context).pushReplacementNamed(AppRouter.resultTest,
          extra: {'resultModel': resultModel});
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}

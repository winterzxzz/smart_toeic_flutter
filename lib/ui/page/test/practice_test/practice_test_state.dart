import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';

class PracticeTestState extends Equatable {
  final TestShow testShow;
  final LoadStatus loadStatus;
  final LoadStatus loadStatusSubmit;
  final String message;
  final String testId;
  final List<QuestionModel> questions;
  final List<QuestionModel> answers;
  final List<QuestionResult> questionsResult;
  final List<PartEnum> parts;
  final String title;
  final PartEnum focusPart;
  final int focusQuestion;
  final Duration duration;
  final bool isShowAnswer;
  final bool isShowQuestionIndex;
  final LoadStatus loadStatusExplain;

  final ResultModel? resultModel;

  final int loadingExplainQuestionId;

  const PracticeTestState({
    required this.loadStatus,
    required this.loadStatusSubmit,
    required this.testShow,
    required this.message,
    required this.testId,
    required this.questions,
    required this.parts,
    required this.title,
    required this.focusPart,
    required this.focusQuestion,
    required this.duration,
    required this.isShowAnswer,
    required this.questionsResult,
    required this.answers,
    required this.isShowQuestionIndex,
    required this.loadStatusExplain,
    required this.resultModel,
    required this.loadingExplainQuestionId,
  });

  // init state

  factory PracticeTestState.initial() {
    return const PracticeTestState(
      loadStatus: LoadStatus.initial,
      loadStatusSubmit: LoadStatus.initial,
      testShow: TestShow.test,
      message: '',
      testId: '',
      questions: [],
      parts: [],
      title: 'New Economy TOEIC Test 1',
      focusPart: PartEnum.part1,
      focusQuestion: 1,
      duration: Duration(minutes: 120),
      isShowAnswer: false,
      questionsResult: [],
      answers: [],
      loadStatusExplain: LoadStatus.initial,
      isShowQuestionIndex: false,
      resultModel: null,
      loadingExplainQuestionId: -1,
    );
  }

  // copy with

  PracticeTestState copyWith({
    LoadStatus? loadStatus,
    TestShow? testShow,
    List<QuestionModel>? questions,
    List<PartEnum>? parts,
    PartEnum? focusPart,
    int? focusQuestion,
    Duration? duration,
    String? title,
    String? message,
    String? testId,
    bool? isShowAnswer,
    List<QuestionResult>? questionsResult,
    List<QuestionModel>? answers,
    LoadStatus? loadStatusExplain,
    bool? isShowQuestionIndex,
    LoadStatus? loadStatusSubmit,
    ResultModel? resultModel,
    int? loadingExplainQuestionId,
  }) {
    return PracticeTestState(
      loadStatus: loadStatus ?? this.loadStatus,
      testShow: testShow ?? this.testShow,
      message: message ?? this.message,
      testId: testId ?? this.testId,
      questions: questions ?? this.questions,
      parts: parts ?? this.parts,
      focusPart: focusPart ?? this.focusPart,
      focusQuestion: focusQuestion ?? this.focusQuestion,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      isShowAnswer: isShowAnswer ?? this.isShowAnswer,
      questionsResult: questionsResult ?? this.questionsResult,
      answers: answers ?? this.answers,
      loadStatusExplain: loadStatusExplain ?? this.loadStatusExplain,
      isShowQuestionIndex: isShowQuestionIndex ?? this.isShowQuestionIndex,
      loadStatusSubmit: loadStatusSubmit ?? this.loadStatusSubmit,
      resultModel: resultModel ?? this.resultModel,
      loadingExplainQuestionId:
          loadingExplainQuestionId ?? this.loadingExplainQuestionId,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        message,
        testShow,
        testId,
        questions,
        parts,
        focusPart,
        focusQuestion,
        duration,
        title,
        message,
        testId,
        isShowAnswer,
        questionsResult,
        answers,
        loadStatusExplain,
        isShowQuestionIndex,
        loadStatusSubmit,
        resultModel,
      ];
}

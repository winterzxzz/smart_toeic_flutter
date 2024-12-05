import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';

class PracticeTestState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final String testId;
  final List<QuestionModel> questions;
  final List<QuestionModel> questionsOfPart;
  final List<QuestionResult> questionsResult;
  final List<PartEnum> parts;
  final String title;
  final PartEnum focusPart;
  final int focusQuestion;
  final Duration duration;
  final bool isShowAnswer;

  const PracticeTestState({
    required this.loadStatus,
    required this.message,
    required this.testId,
    required this.questions,
    required this.questionsOfPart,
    required this.parts,
    required this.title,
    required this.focusPart,  
    required this.focusQuestion,
    required this.duration,
    required this.isShowAnswer,
    required this.questionsResult,
  });

  // init state

  factory PracticeTestState.initial() {
    return PracticeTestState(
      loadStatus: LoadStatus.initial,
      message: '',
      testId: '',
      questions: [],
      questionsOfPart: [],
      parts: [],
      title: 'New Economy TOEIC Test 1',
      focusPart: PartEnum.part1,
      focusQuestion: 1,
      duration: Duration(minutes: 120),
      isShowAnswer: false,
      questionsResult: [],
    );
  }

  // copy with

  PracticeTestState copyWith({
    LoadStatus? loadStatus,
    List<QuestionModel>? questions,
    List<QuestionModel>? questionsOfPart,
    List<PartEnum>? parts,
    PartEnum? focusPart,
    int? focusQuestion,
    Duration? duration,
    String? title,
    String? message,
    String? testId,
    bool? isShowAnswer,
    List<QuestionResult>? questionsResult,
  }) {
    return PracticeTestState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      testId: testId ?? this.testId,
      questions: questions ?? this.questions,
      questionsOfPart: questionsOfPart ?? this.questionsOfPart,
      parts: parts ?? this.parts,
      focusPart: focusPart ?? this.focusPart,
      focusQuestion: focusQuestion ?? this.focusQuestion,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      isShowAnswer: isShowAnswer ?? this.isShowAnswer,
      questionsResult: questionsResult ?? this.questionsResult,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        message,
        testId,
        questions,
        questionsOfPart,
        parts,
        focusPart,
        focusQuestion,
        duration,
        title,
        message,
        testId,
        isShowAnswer,
        questionsResult,
      ];
}

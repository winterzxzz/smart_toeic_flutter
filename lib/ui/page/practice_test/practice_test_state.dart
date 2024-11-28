import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';

class PracticeTestState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final String testId;
  final List<QuestionModel> questions;
  final List<QuestionModel> questionsOfPart;
  final List<PartEnum> parts;
  final String title;
  final PartEnum focusPart;
  final int focusQuestion;
  final Duration duration;
  final bool isTestMode;

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
    required this.isTestMode,
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
      isTestMode: false,
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
    bool? isTestMode,
    String? title,
    String? message,
    String? testId,
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
      isTestMode: isTestMode ?? this.isTestMode,
      title: title ?? this.title,
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
        isTestMode,
        title,
        message,
        testId,
      ];
}

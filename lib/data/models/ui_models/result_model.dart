import 'package:toeic_desktop/data/models/ui_models/question.dart';

class ResultModel {
  final String testName;
  final int totalQuestion;
  final int correctQuestion;
  final int incorrectQuestion;
  final int notAnswerQuestion;
  final int overallScore;
  final int listeningScore;
  final int readingScore;
  final Duration duration;
  final List<QuestionModel> questions;

  ResultModel({
    required this.testName,
    required this.totalQuestion,
    required this.correctQuestion,
    required this.incorrectQuestion,
    required this.notAnswerQuestion,
    required this.overallScore,
    required this.listeningScore,
    required this.readingScore,
    required this.duration,
    required this.questions,
  });
}

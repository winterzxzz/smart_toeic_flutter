class ResultModel {
  final String resultId;
  final String testName;
  final int totalQuestion;
  final int correctQuestion;
  final int incorrectQuestion;
  final int notAnswerQuestion;
  final int overallScore;
  final int listeningScore;
  final int readingScore;
  final Duration duration;

  ResultModel({
    required this.resultId,
    required this.testName,
    required this.totalQuestion,
    required this.correctQuestion,
    required this.incorrectQuestion,
    required this.notAnswerQuestion,
    required this.overallScore,
    required this.listeningScore,
    required this.readingScore,
    required this.duration,
  });
}

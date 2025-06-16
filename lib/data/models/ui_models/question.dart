import 'package:toeic_desktop/data/models/entities/test/question.dart';
import 'package:toeic_desktop/data/models/entities/test/question_explain.dart'
    as x;

class QuestionModel {
  final int id;
  final String? image;
  final String? audio;
  final String? paragraph;
  final String? question;
  final String option1;
  final String option2;
  final String option3;
  final String? option4;
  final List<Option> options;
  final String correctAnswer;
  final int part;
  final String? userAnswer;
  final int timeSecond;
  final List<String> questionCategory;
  final x.QuestionExplain? questionExplain;

  QuestionModel({
    required this.id,
    this.image,
    this.audio,
    this.paragraph,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    this.option4,
    required this.options,
    required this.correctAnswer,
    required this.part,
    this.userAnswer,
    this.timeSecond = 0,
    this.questionCategory = const [],
    this.questionExplain,
  });


  // copy with
  QuestionModel copyWith({
    int? id,
    String? image,
    String? audio,
    String? paragraph,
    String? question,
    String? option1,
    String? option2,
    String? option3,
    String? option4,
    List<Option>? options,
    String? correctAnswer,
    int? part,
    String? userAnswer,
    int? timeSecond,
    List<String>? questionCategory,
    x.QuestionExplain? questionExplain,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      image: image ?? this.image,
      audio: audio ?? this.audio,
      paragraph: paragraph ?? this.paragraph,
      question: question ?? this.question,
      option1: option1 ?? this.option1,
      option2: option2 ?? this.option2,
      option3: option3 ?? this.option3,
      option4: option4 ?? this.option4,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      part: part ?? this.part,
      userAnswer: userAnswer ?? this.userAnswer,
      timeSecond: timeSecond ?? this.timeSecond,
      questionCategory: questionCategory ?? this.questionCategory,
      questionExplain: questionExplain ?? this.questionExplain,
    );
  }
}

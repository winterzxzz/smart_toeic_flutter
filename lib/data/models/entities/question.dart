// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/entities/option.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';

part 'question.g.dart';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Question {
    @JsonKey(name: "id")
    int id;
    @JsonKey(name: "number")
    int number;
    @JsonKey(name: "image")
    String? image;
    @JsonKey(name: "audio")
    String? audio;
    @JsonKey(name: "paragraph")
    String? paragraph;
    @JsonKey(name: "option1")
    dynamic option1;
    @JsonKey(name: "option2")
    dynamic option2;
    @JsonKey(name: "option3")
    dynamic option3;
    @JsonKey(name: "option4")
    dynamic option4;
    @JsonKey(name: "correctanswer")
    String correctanswer;
    @JsonKey(name: "options")
    List<Option> options;
    @JsonKey(name: "question")
    String? question;

    Question({
        required this.id,
        required this.number,
        this.image,
        this.audio,
        this.paragraph,
        required this.option1,
        required this.option2,
        required this.option3,
        this.option4,
        required this.correctanswer,
        required this.options,
        this.question,
    });

    factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

    Map<String, dynamic> toJson() => _$QuestionToJson(this);





  // final int id;
  // final String? image;
  // final String? audio;
  // final String? paragraph;
  // final String? question;
  // final String option1;
  // final String option2;
  // final String option3;
  // final String? option4;
  // final String correctAnswer;
  // final int part;
  // final String? userAnswer;
    QuestionModel toQuestionModel() => QuestionModel(
      id: id,
      image: image,
      audio: audio,
      paragraph: paragraph,
      question: question,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      correctAnswer: correctanswer,
      part: number,
      userAnswer: null,
    );
}

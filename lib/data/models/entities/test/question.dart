// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/ui_models/question.dart';

part 'question.g.dart';

List<Question> questionFromJson(String str) =>
    List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Question {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "number")
  final int? number;
  @JsonKey(name: "image")
  final String? image;
  @JsonKey(name: "audio")
  final String? audio;
  @JsonKey(name: "paragraph")
  final String? paragraph;
  @JsonKey(name: "option1")
  final dynamic option1;
  @JsonKey(name: "option2")
  final dynamic option2;
  @JsonKey(name: "option3")
  final dynamic option3;
  @JsonKey(name: "option4")
  final dynamic option4;
  @JsonKey(name: "correctanswer")
  final Correctanswer? correctanswer;
  @JsonKey(name: "options")
  final List<Option>? options;
  @JsonKey(name: "question")
  final String? question;

  Question({
    this.id,
    this.number,
    this.image,
    this.audio,
    this.paragraph,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctanswer,
    this.options,
    this.question,
  });
  QuestionModel toQuestionModel() {
    int part;

    if (number! >= 1 && number! <= 3) {
      part = 1;
    } else if (number! >= 4 && number! <= 14) {
      part = 2;
    } else if (number! >= 15 && number! <= 32) {
      part = 3;
    } else if (number! >= 33 && number! <= 50) {
      part = 4;
    } else if (number! >= 51 && number! <= 64) {
      part = 5;
    } else if (number! >= 65 && number! <= 73) {
      part = 6;
    } else {
      part = 7;
    }

    return QuestionModel(
      id: id!,
      image: image,
      audio: audio,
      paragraph: paragraph,
      question: question,
      option1: option1.toString(),
      option2: option2.toString(),
      option3: option3.toString(),
      option4: option4.toString(),
      options: options ?? [],
      correctAnswer: correctanswer?.value ?? '',
      part: part,
      userAnswer: null,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

enum Correctanswer {
  @JsonValue("A")
  A,
  @JsonValue("B")
  B,
  @JsonValue("C")
  C,
  @JsonValue("D")
  D
}

extension CorrectanswerExtension on Correctanswer {
  String get value => correctanswerValues.reverse[this]!;
}

final correctanswerValues = EnumValues({
  "A": Correctanswer.A,
  "B": Correctanswer.B,
  "C": Correctanswer.C,
  "D": Correctanswer.D
});

@JsonSerializable()
class Option {
  @JsonKey(name: "id")
  final Correctanswer? id;
  @JsonKey(name: "content")
  final dynamic content;

  Option({
    this.id,
    this.content,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

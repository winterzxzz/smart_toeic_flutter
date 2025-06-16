// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/ui_models/question.dart';

part 'question.g.dart';

List<Question> questionFromJson(String str) => List<Question>.from(
      json
          .decode(str)
          .where((x) => x["id"] != "" || (x["options"] as List).isNotEmpty)
          .map((x) {
        debugPrint(x["id"]);
        return Question.fromJson(x);
      }),
    );

String questionToJson(List<Question> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Question {
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "number")
  int? number;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "audio")
  final String? audio;
  @JsonKey(name: "paragraph")
  final String? paragraph;
  @JsonKey(name: "option1")
  dynamic option1;
  @JsonKey(name: "option2")
  dynamic option2;
  @JsonKey(name: "option3")
  dynamic option3;
  @JsonKey(name: "option4")
  dynamic option4;
  @JsonKey(name: "correctanswer")
  String? correctanswer;
  @JsonKey(name: "options")
  List<Option> options;
  @JsonKey(name: "question")
  String? question;

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
    this.options = const [],
    this.question,
  });
  QuestionModel toQuestionModel() {
    int part;
    if (number == null) {
      part = 0;
    } else if (number! >= 1 && number! <= 6) {
      part = 1;
    } else if (number! >= 7 && number! <= 31) {
      part = 2;
    } else if (number! >= 32 && number! <= 70) {
      part = 3;
    } else if (number! >= 71 && number! <= 100) {
      part = 4;
    } else if (number! >= 101 && number! <= 130) {
      part = 5;
    } else if (number! >= 131 && number! <= 160) {
      part = 6;
    } else {
      part = 7;
    }

    return QuestionModel(
      id: id,
      image: image,
      audio: audio,
      paragraph: paragraph,
      question: question,
      option1: option1.toString(),
      option2: option2.toString(),
      option3: option3.toString(),
      option4: option4.toString(),
      options: options,
      correctAnswer: correctanswer ?? '',
      part: part,
      userAnswer: null,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Option {
  @JsonKey(name: "id")
  final String? id;
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

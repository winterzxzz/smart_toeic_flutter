// To parse this JSON data, do
//
//     final questionExplain = questionExplainFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'question_explain.g.dart';

QuestionExplain questionExplainFromJson(String str) =>
    QuestionExplain.fromJson(json.decode(str));

String questionExplainToJson(QuestionExplain data) =>
    json.encode(data.toJson());

@JsonSerializable()
class QuestionExplain {
  @JsonKey(name: "correctAnswer")
  String correctAnswer;
  @JsonKey(name: "explanation")
  Explanation explanation;
  @JsonKey(name: "options")
  List<Option> options;

  QuestionExplain({
    required this.correctAnswer,
    required this.explanation,
    required this.options,
  });

  factory QuestionExplain.fromJson(Map<String, dynamic> json) =>
      _$QuestionExplainFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionExplainToJson(this);
}

@JsonSerializable()
class Explanation {
  @JsonKey(name: "correctReason")
  String correctReason;
  @JsonKey(name: "incorrectReasons")
  IncorrectReasons incorrectReasons;

  Explanation({
    required this.correctReason,
    required this.incorrectReasons,
  });

  factory Explanation.fromJson(Map<String, dynamic> json) =>
      _$ExplanationFromJson(json);

  Map<String, dynamic> toJson() => _$ExplanationToJson(this);
}

@JsonSerializable()
class IncorrectReasons {
  @JsonKey(name: "A")
  String a;
  @JsonKey(name: "B")
  String b;
  @JsonKey(name: "C")
  String c;
  @JsonKey(name: "D")
  String d;

  IncorrectReasons({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  String getReason(String key) {
    switch (key) {
      case "A":
        return a;
      case "B":
        return b;
      case "C":
        return c;
      case "D":
        return d;
      default:
        return "";
    }
  }

  factory IncorrectReasons.fromJson(Map<String, dynamic> json) =>
      _$IncorrectReasonsFromJson(json);

  Map<String, dynamic> toJson() => _$IncorrectReasonsToJson(this);
}

@JsonSerializable()
class Option {
  @JsonKey(name: "label")
  String label;
  @JsonKey(name: "text")
  String text;

  Option({
    required this.label,
    required this.text,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_explain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionExplain _$QuestionExplainFromJson(Map<String, dynamic> json) =>
    QuestionExplain(
      correctAnswer: json['correctAnswer'] as String,
      explanation:
          Explanation.fromJson(json['explanation'] as Map<String, dynamic>),
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionExplainToJson(QuestionExplain instance) =>
    <String, dynamic>{
      'correctAnswer': instance.correctAnswer,
      'explanation': instance.explanation,
      'options': instance.options,
    };

Explanation _$ExplanationFromJson(Map<String, dynamic> json) => Explanation(
      correctReason: json['correctReason'] as String,
      incorrectReasons: IncorrectReasons.fromJson(
          json['incorrectReasons'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExplanationToJson(Explanation instance) =>
    <String, dynamic>{
      'correctReason': instance.correctReason,
      'incorrectReasons': instance.incorrectReasons,
    };

IncorrectReasons _$IncorrectReasonsFromJson(Map<String, dynamic> json) =>
    IncorrectReasons(
      a: json['A'] as String,
      b: json['B'] as String,
      c: json['C'] as String,
      d: json['D'] as String,
    );

Map<String, dynamic> _$IncorrectReasonsToJson(IncorrectReasons instance) =>
    <String, dynamic>{
      'A': instance.a,
      'B': instance.b,
      'C': instance.c,
      'D': instance.d,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      label: json['label'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'label': instance.label,
      'text': instance.text,
    };

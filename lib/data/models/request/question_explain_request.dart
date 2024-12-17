// To parse this JSON data, do
//
//     final QuestionExplainRequest = QuestionExplainRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/entities/test/question.dart';

part 'question_explain_request.g.dart';

QuestionExplainRequest questinExplainRequestFromJson(String str) => QuestionExplainRequest.fromJson(json.decode(str));

String questinExplainRequestToJson(QuestionExplainRequest data) => json.encode(data.toJson());

@JsonSerializable()
class QuestionExplainRequest {
    @JsonKey(name: "prompt")
    Question prompt;

    QuestionExplainRequest({
        required this.prompt,
    });

    factory QuestionExplainRequest.fromJson(Map<String, dynamic> json) => _$QuestionExplainRequestFromJson(json);

    Map<String, dynamic> toJson() => _$QuestionExplainRequestToJson(this);
}

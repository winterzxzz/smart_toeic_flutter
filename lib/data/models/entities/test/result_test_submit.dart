// To parse this JSON data, do
//
//     final resultTestSubmit = resultTestSubmitFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'result_test_submit.g.dart';

ResultTestSubmit resultTestSubmitFromJson(String str) => ResultTestSubmit.fromJson(json.decode(str));

String resultTestSubmitToJson(ResultTestSubmit data) => json.encode(data.toJson());

@JsonSerializable()
class ResultTestSubmit {
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "testId")
    String testId;
    @JsonKey(name: "testType")
    String testType;
    @JsonKey(name: "numberOfQuestions")
    int numberOfQuestions;
    @JsonKey(name: "numberOfUserAnswers")
    int numberOfUserAnswers;
    @JsonKey(name: "numberOfCorrectAnswers")
    int numberOfCorrectAnswers;
    @JsonKey(name: "secondTime")
    int secondTime;
    @JsonKey(name: "parts")
    List<dynamic> parts;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "id")
    String id;

    ResultTestSubmit({
        required this.userId,
        required this.testId,
        required this.testType,
        required this.numberOfQuestions,
        required this.numberOfUserAnswers,
        required this.numberOfCorrectAnswers,
        required this.secondTime,
        required this.parts,
        required this.createdAt,
        required this.updatedAt,
        required this.id,
    });

    factory ResultTestSubmit.fromJson(Map<String, dynamic> json) => _$ResultTestSubmitFromJson(json);

    Map<String, dynamic> toJson() => _$ResultTestSubmitToJson(this);
}

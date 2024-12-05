// To parse this JSON data, do
//
//     final questionResult = questionResultFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'question_result.g.dart';

List<QuestionResult> questionResultFromJson(String str) => List<QuestionResult>.from(json.decode(str).map((x) => QuestionResult.fromJson(x)));

String questionResultToJson(List<QuestionResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class QuestionResult {
    @JsonKey(name: "useranswer")
    String useranswer;
    @JsonKey(name: "correctanswer")
    String correctanswer;
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "questionNum")
    String questionNum;
    @JsonKey(name: "testId")
    String testId;
    @JsonKey(name: "testType")
    String testType;
    @JsonKey(name: "resultId")
    String resultId;
    @JsonKey(name: "part")
    int questionResultPart;
    @JsonKey(name: "isReading")
    bool isReading;
    @JsonKey(name: "timeSecond")
    int timeSecond;
    @JsonKey(name: "questionCategory")
    List<dynamic> questionCategory;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "id")
    String id;

    QuestionResult({
        required this.useranswer,
        required this.correctanswer,
        required this.userId,
        required this.questionNum,
        required this.testId,
        required this.testType,
        required this.resultId,
        required this.questionResultPart,
        required this.isReading,
        required this.timeSecond,
        required this.questionCategory,
        required this.createdAt,
        required this.updatedAt,
        required this.id,
    });

    factory QuestionResult.fromJson(Map<String, dynamic> json) => _$QuestionResultFromJson(json);

    Map<String, dynamic> toJson() => _$QuestionResultToJson(this);
}

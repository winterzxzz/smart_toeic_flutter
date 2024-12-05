// To parse this JSON data, do
//
//     final resultTest = resultTestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'result_test.g.dart';

List<ResultTest> resultTestFromJson(String str) => List<ResultTest>.from(json.decode(str).map((x) => ResultTest.fromJson(x)));

String resultTestToJson(List<ResultTest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ResultTest {
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "testId")
    TestId testId;
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
    List<int> parts;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "id")
    String id;

    ResultTest({
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

    factory ResultTest.fromJson(Map<String, dynamic> json) => _$ResultTestFromJson(json);

    Map<String, dynamic> toJson() => _$ResultTestToJson(this);
}

@JsonSerializable()
class TestId {
    @JsonKey(name: "title")
    String title;
    @JsonKey(name: "type")
    String type;
    @JsonKey(name: "attempts")
    List<Attempt> attempts;
    @JsonKey(name: "code")
    String code;
    @JsonKey(name: "numberOfQuestions")
    int numberOfQuestions;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "duration")
    int duration;
    @JsonKey(name: "fileName")
    String fileName;
    @JsonKey(name: "parts")
    List<int> parts;
    @JsonKey(name: "numberOfParts")
    int numberOfParts;
    @JsonKey(name: "id")
    String id;

    TestId({
        required this.title,
        required this.type,
        required this.attempts,
        required this.code,
        required this.numberOfQuestions,
        required this.createdAt,
        required this.updatedAt,
        required this.duration,
        required this.fileName,
        required this.parts,
        required this.numberOfParts,
        required this.id,
    });

    factory TestId.fromJson(Map<String, dynamic> json) => _$TestIdFromJson(json);

    Map<String, dynamic> toJson() => _$TestIdToJson(this);
}

@JsonSerializable()
class Attempt {
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "times")
    int times;

    Attempt({
        required this.userId,
        required this.times,
    });

    factory Attempt.fromJson(Map<String, dynamic> json) => _$AttemptFromJson(json);

    Map<String, dynamic> toJson() => _$AttemptToJson(this);
}

// To parse this JSON data, do
//
//     final test = testFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'test.g.dart';

List<Test> testFromJson(String str) => List<Test>.from(json.decode(str).map((x) => Test.fromJson(x)));

String testToJson(List<Test> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Test {
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

    Test({
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

    factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

    Map<String, dynamic> toJson() => _$TestToJson(this);
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

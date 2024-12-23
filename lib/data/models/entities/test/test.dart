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
    final String? title;
    @JsonKey(name: "type")
    final String? type;
    @JsonKey(name: "code")
    final String? code;
    @JsonKey(name: "numberOfQuestions")
    final int? numberOfQuestions;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;
    @JsonKey(name: "duration")
    final int? duration;
    @JsonKey(name: "attemptCount")
    final int? attemptCount;
    @JsonKey(name: "userAttempt")
    final UserAttempt? userAttempt;
    @JsonKey(name: "id")
    final String? id;

    Test({
        this.title,
        this.type,
        this.code,
        this.numberOfQuestions,
        this.createdAt,
        this.updatedAt,
        this.duration,
        this.attemptCount,
        this.userAttempt,
        this.id,
    });

    factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

    Map<String, dynamic> toJson() => _$TestToJson(this);
}

@JsonSerializable()
class UserAttempt {
    @JsonKey(name: "count")
    final int? count;
    @JsonKey(name: "lastTime")
    final dynamic lastTime;

    UserAttempt({
        this.count,
        this.lastTime,
    });

    factory UserAttempt.fromJson(Map<String, dynamic> json) => _$UserAttemptFromJson(json);

    Map<String, dynamic> toJson() => _$UserAttemptToJson(this);
}

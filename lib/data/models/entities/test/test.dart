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
    String? title;
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "numberOfParts")
    int? numberOfParts;
    @JsonKey(name: "code")
    String? code;
    @JsonKey(name: "numberOfQuestions")
    int? numberOfQuestions;
    @JsonKey(name: "createdAt")
    DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt;
    @JsonKey(name: "duration")
    int? duration;
    @JsonKey(name: "parts")
    List<int>? parts;
    @JsonKey(name: "isPublished")
    bool? isPublished;
    @JsonKey(name: "difficulty")
    String? difficulty;
    @JsonKey(name: "attemptCount")
    int? attemptCount;
    @JsonKey(name: "userAttempt")
    UserAttempt? userAttempt;
    @JsonKey(name: "id")
    String? id;

    Test({
        this.title,
        this.type,
        this.numberOfParts,
        this.code,
        this.numberOfQuestions,
        this.createdAt,
        this.updatedAt,
        this.duration,
        this.parts,
        this.isPublished,
        this.difficulty,
        this.attemptCount,
        this.userAttempt,
        this.id,
    });

    Test copyWith({
        String? title,
        String? type,
        int? numberOfParts,
        String? code,
        int? numberOfQuestions,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? duration,
        List<int>? parts,
        bool? isPublished,
        String? difficulty,
        int? attemptCount,
        UserAttempt? userAttempt,
        String? id,
    }) => 
        Test(
            title: title ?? this.title,
            type: type ?? this.type,
            numberOfParts: numberOfParts ?? this.numberOfParts,
            code: code ?? this.code,
            numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            duration: duration ?? this.duration,
            parts: parts ?? this.parts,
            isPublished: isPublished ?? this.isPublished,
            difficulty: difficulty ?? this.difficulty,
            attemptCount: attemptCount ?? this.attemptCount,
            userAttempt: userAttempt ?? this.userAttempt,
            id: id ?? this.id,
        );

    factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

    Map<String, dynamic> toJson() => _$TestToJson(this);
}

@JsonSerializable()
class UserAttempt {
    @JsonKey(name: "count")
    int? count;
    @JsonKey(name: "lastTime")
    DateTime? lastTime;

    UserAttempt({
        this.count,
        this.lastTime,
    });

    UserAttempt copyWith({
        int? count,
        DateTime? lastTime,
    }) => 
        UserAttempt(
            count: count ?? this.count,
            lastTime: lastTime ?? this.lastTime,
        );

    factory UserAttempt.fromJson(Map<String, dynamic> json) => _$UserAttemptFromJson(json);

    Map<String, dynamic> toJson() => _$UserAttemptToJson(this);
}

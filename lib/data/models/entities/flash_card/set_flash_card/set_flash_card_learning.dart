// To parse this JSON data, do
//
//     final setFlashCardLearning = setFlashCardLearningFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'set_flash_card_learning.g.dart';

List<SetFlashCardLearning> setFlashCardLearningFromJson(String str) => List<SetFlashCardLearning>.from(json.decode(str).map((x) => SetFlashCardLearning.fromJson(x)));

String setFlashCardLearningToJson(List<SetFlashCardLearning> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class SetFlashCardLearning {
    @JsonKey(name: "_id")
    String id;
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "setFlashcardId")
    SetFlashcardId setFlashcardId;
    @JsonKey(name: "lastStudied")
    DateTime lastStudied;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "__v")
    int v;
    @JsonKey(name: "learningFlashcards")
    List<double> learningFlashcards;
    @JsonKey(name: "id")
    String setFlashCardLearningId;

    SetFlashCardLearning({
        required this.id,
        required this.userId,
        required this.setFlashcardId,
        required this.lastStudied,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.learningFlashcards,
        required this.setFlashCardLearningId,
    });

    factory SetFlashCardLearning.fromJson(Map<String, dynamic> json) => _$SetFlashCardLearningFromJson(json);

    Map<String, dynamic> toJson() => _$SetFlashCardLearningToJson(this);
}

@JsonSerializable()
class SetFlashcardId {
    @JsonKey(name: "_id")
    String id;
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "title")
    String title;
    @JsonKey(name: "description")
    String description;
    @JsonKey(name: "isPublic")
    bool isPublic;
    @JsonKey(name: "userRole")
    String userRole;
    @JsonKey(name: "numberOfFlashcards")
    int numberOfFlashcards;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "__v")
    int v;

    SetFlashcardId({
        required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.isPublic,
        required this.userRole,
        required this.numberOfFlashcards,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory SetFlashcardId.fromJson(Map<String, dynamic> json) => _$SetFlashcardIdFromJson(json);

    Map<String, dynamic> toJson() => _$SetFlashcardIdToJson(this);
}

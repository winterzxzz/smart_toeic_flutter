// To parse this JSON data, do
//
//     final learningFlashCard = learningFlashCardFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/entities/flash_card.dart';

part 'learning_flash_card.g.dart';

List<LearningFlashCard> learningFlashCardFromJson(String str) => List<LearningFlashCard>.from(json.decode(str).map((x) => LearningFlashCard.fromJson(x)));

String learningFlashCardToJson(List<LearningFlashCard> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class LearningFlashCard {
    @JsonKey(name: "_id")
    String id;
    @JsonKey(name: "userId")
    String userId;
    @JsonKey(name: "setFlashcardId")
    FlashCard setFlashcardId;
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
    String learningFlashCardId;

    LearningFlashCard({
        required this.id,
        required this.userId,
        required this.setFlashcardId,
        required this.lastStudied,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.learningFlashcards,
        required this.learningFlashCardId,
    });

    factory LearningFlashCard.fromJson(Map<String, dynamic> json) => _$LearningFlashCardFromJson(json);

    Map<String, dynamic> toJson() => _$LearningFlashCardToJson(this);
}

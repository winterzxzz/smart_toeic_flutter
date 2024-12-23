// To parse this JSON data, do
//
//     final newSetFlashCardLearning = newSetFlashCardLearningFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'new_set_flash_card_learning.g.dart';

NewSetFlashCardLearning newSetFlashCardLearningFromJson(String str) => NewSetFlashCardLearning.fromJson(json.decode(str));

String newSetFlashCardLearningToJson(NewSetFlashCardLearning data) => json.encode(data.toJson());

@JsonSerializable()
class NewSetFlashCardLearning {
    @JsonKey(name: "userId")
    final String? userId;
    @JsonKey(name: "setFlashcardId")
    final String? setFlashcardId;
    @JsonKey(name: "lastStudied")
    final DateTime? lastStudied;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;
    @JsonKey(name: "id")
    final String? id;

    NewSetFlashCardLearning({
        this.userId,
        this.setFlashcardId,
        this.lastStudied,
        this.createdAt,
        this.updatedAt,
        this.id,
    });

    factory NewSetFlashCardLearning.fromJson(Map<String, dynamic> json) => _$NewSetFlashCardLearningFromJson(json);

    Map<String, dynamic> toJson() => _$NewSetFlashCardLearningToJson(this);
}

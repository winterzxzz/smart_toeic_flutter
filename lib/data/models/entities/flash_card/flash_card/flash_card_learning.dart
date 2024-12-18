// To parse this JSON data, do
//
//     final flashCardLearning = flashCardLearningFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';

part 'flash_card_learning.g.dart';

List<FlashCardLearning> flashCardLearningFromJson(String str) => List<FlashCardLearning>.from(json.decode(str).map((x) => FlashCardLearning.fromJson(x)));

String flashCardLearningToJson(List<FlashCardLearning> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FlashCardLearning {
    @JsonKey(name: "flashcardId")
    final FlashCard? flashcardId;
    @JsonKey(name: "retentionScore")
    final double? retentionScore;
    @JsonKey(name: "decayScore")
    final double? decayScore;
    @JsonKey(name: "studyTime")
    final int? studyTime;
    @JsonKey(name: "EF")
    final double? ef;
    @JsonKey(name: "learningSetId")
    final String? learningSetId;
    @JsonKey(name: "optimalTime")
    final DateTime? optimalTime;
    @JsonKey(name: "interval")
    final int? interval;
    @JsonKey(name: "lastStudied")
    final DateTime? lastStudied;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;
    @JsonKey(name: "id")
    final String? id;

    FlashCardLearning({
        this.flashcardId,
        this.retentionScore,
        this.decayScore,
        this.studyTime,
        this.ef,
        this.learningSetId,
        this.optimalTime,
        this.interval,
        this.lastStudied,
        this.createdAt,
        this.updatedAt,
        this.id,
    });

    factory FlashCardLearning.fromJson(Map<String, dynamic> json) => _$FlashCardLearningFromJson(json);

    Map<String, dynamic> toJson() => _$FlashCardLearningToJson(this);
}

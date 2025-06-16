// To parse this JSON data, do
//
//     final flashCard = flashCardFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'flash_card.g.dart';

List<FlashCard> flashCardFromJson(String str) =>
    List<FlashCard>.from(json.decode(str).map((x) => FlashCard.fromJson(x)));

String flashCardToJson(List<FlashCard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FlashCard {
  @JsonKey(name: "setFlashcardId")
  String? setFlashcardId;
  @JsonKey(name: "word")
  String word;
  @JsonKey(name: "translation")
  String translation;
  @JsonKey(name: "definition")
  String definition;
  @JsonKey(name: "exampleSentence")
  List<String> exampleSentence;
  @JsonKey(name: "note")
  String note;
  @JsonKey(name: "partOfSpeech")
  List<String> partOfSpeech;
  @JsonKey(name: "pronunciation")
  String pronunciation;
  @JsonKey(name: "createdAt")
  DateTime createdAt;
  @JsonKey(name: "updatedAt")
  DateTime updatedAt;
  @JsonKey(name: "id")
  String id;

  FlashCard({
    required this.setFlashcardId,
    required this.word,
    required this.translation,
    required this.definition,
    required this.exampleSentence,
    required this.note,
    required this.partOfSpeech,
    required this.pronunciation,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) =>
      _$FlashCardFromJson(json);

  Map<String, dynamic> toJson() => _$FlashCardToJson(this);
}

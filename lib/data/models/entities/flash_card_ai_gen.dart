// To parse this JSON data, do
//
//     final flashCardAiGen = flashCardAiGenFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'flash_card_ai_gen.g.dart';

FlashCardAiGen flashCardAiGenFromJson(String str) =>
    FlashCardAiGen.fromJson(json.decode(str));

String flashCardAiGenToJson(FlashCardAiGen data) => json.encode(data.toJson());

@JsonSerializable()
class FlashCardAiGen {
  @JsonKey(name: "definition")
  String definition;
  @JsonKey(name: "example1")
  String example1;
  @JsonKey(name: "example2")
  String example2;
  @JsonKey(name: "note")
  String note;
  @JsonKey(name: "partOfSpeech")
  List<String> partOfSpeech;
  @JsonKey(name: "pronunciation")
  String pronunciation;
  @JsonKey(name: "translation")
  String translation;
  @JsonKey(name: "word")
  String word;

  FlashCardAiGen({
    required this.definition,
    required this.example1,
    required this.example2,
    required this.note,
    required this.partOfSpeech,
    required this.pronunciation,
    required this.translation,
    required this.word,
  });

  factory FlashCardAiGen.fromJson(Map<String, dynamic> json) =>
      _$FlashCardAiGenFromJson(json);

  Map<String, dynamic> toJson() => _$FlashCardAiGenToJson(this);
}

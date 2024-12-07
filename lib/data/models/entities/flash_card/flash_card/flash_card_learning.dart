// To parse this JSON data, do
//
//     final flashCardLearning = flashCardLearningFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'flash_card_learning.g.dart';

List<FlashCardLearning> flashCardLearningFromJson(String str) => List<FlashCardLearning>.from(json.decode(str).map((x) => FlashCardLearning.fromJson(x)));

String flashCardLearningToJson(List<FlashCardLearning> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FlashCardLearning {
    @JsonKey(name: "flashcardId")
    FlashcardId flashcardId;
    @JsonKey(name: "retentionScore")
    double retentionScore;
    @JsonKey(name: "decayScore")
    double decayScore;
    @JsonKey(name: "studyTime")
    int studyTime;
    @JsonKey(name: "EF")
    double ef;
    @JsonKey(name: "learningSetId")
    String learningSetId;
    @JsonKey(name: "optimalTime")
    DateTime? optimalTime;
    @JsonKey(name: "interval")
    int interval;
    @JsonKey(name: "lastStudied")
    DateTime lastStudied;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "id")
    String id;

    FlashCardLearning({
        required this.flashcardId,
        required this.retentionScore,
        required this.decayScore,
        required this.studyTime,
        required this.ef,
        required this.learningSetId,
        required this.optimalTime,
        required this.interval,
        required this.lastStudied,
        required this.createdAt,
        required this.updatedAt,
        required this.id,
    });

    factory FlashCardLearning.fromJson(Map<String, dynamic> json) => _$FlashCardLearningFromJson(json);

    Map<String, dynamic> toJson() => _$FlashCardLearningToJson(this);
}

@JsonSerializable()
class FlashcardId {
    @JsonKey(name: "setFlashcardId")
    String setFlashcardId;
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
    List<PartOfSpeech> partOfSpeech;
    @JsonKey(name: "pronunciation")
    String pronunciation;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "id")
    String id;

    FlashcardId({
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

    factory FlashcardId.fromJson(Map<String, dynamic> json) => _$FlashcardIdFromJson(json);

    Map<String, dynamic> toJson() => _$FlashcardIdToJson(this);
}

enum PartOfSpeech {
    @JsonValue("noun")
    NOUN,
    @JsonValue("verb")
    VERB
}

final partOfSpeechValues = EnumValues({
    "noun": PartOfSpeech.NOUN,
    "verb": PartOfSpeech.VERB
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}

// To parse this JSON data, do
//
//     final wordRandom = wordRandomFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'word_random.g.dart';

List<WordRandom> wordRandomFromJson(String str) => List<WordRandom>.from(json.decode(str).map((x) => WordRandom.fromJson(x)));

String wordRandomToJson(List<WordRandom> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class WordRandom {
    @JsonKey(name: "id")
    String? id;
    @JsonKey(name: "word")
    String? word;
    @JsonKey(name: "translation")
    String? translation;
    @JsonKey(name: "description")
    String? description;
    @JsonKey(name: "__v")
    int? v;
    @JsonKey(name: "createdAt")
    DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt;

    WordRandom({
        this.id,
        this.word,
        this.translation,
        this.description,
        this.v,
        this.createdAt,
        this.updatedAt,
    });

    WordRandom copyWith({
        String? id,
        String? word,
        String? translation,
        String? description,
        int? v,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        WordRandom(
            id: id ?? this.id,
            word: word ?? this.word,
            translation: translation ?? this.translation,
            description: description ?? this.description,
            v: v ?? this.v,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory WordRandom.fromJson(Map<String, dynamic> json) => _$WordRandomFromJson(json);

    Map<String, dynamic> toJson() => _$WordRandomToJson(this);
}

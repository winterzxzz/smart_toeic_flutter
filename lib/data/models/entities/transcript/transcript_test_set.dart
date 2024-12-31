// To parse this JSON data, do
//
//     final transcriptTestSet = transcriptTestSetFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transcript_test_set.g.dart';

List<TranscriptTestSet> transcriptTestSetFromJson(String str) => List<TranscriptTestSet>.from(json.decode(str).map((x) => TranscriptTestSet.fromJson(x)));

String transcriptTestSetToJson(List<TranscriptTestSet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TranscriptTestSet {
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "url")
    String? url;
    @JsonKey(name: "attempts")
    List<dynamic>? attempts;
    @JsonKey(name: "code")
    String? code;
    @JsonKey(name: "description")
    String? description;
    @JsonKey(name: "createdAt")
    DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt;
    @JsonKey(name: "image")
    String? image;
    @JsonKey(name: "part")
    dynamic transcriptTestSetPart;
    @JsonKey(name: "id")
    String? id;

    TranscriptTestSet({
        this.title,
        this.url,
        this.attempts,
        this.code,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.transcriptTestSetPart,
        this.id,
    });

    TranscriptTestSet copyWith({
        String? title,
        String? url,
        List<dynamic>? attempts,
        String? code,
        String? description,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? image,
        dynamic transcriptTestSetPart,
        String? id,
    }) => 
        TranscriptTestSet(
            title: title ?? this.title,
            url: url ?? this.url,
            attempts: attempts ?? this.attempts,
            code: code ?? this.code,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            image: image ?? this.image,
            transcriptTestSetPart: transcriptTestSetPart ?? this.transcriptTestSetPart,
            id: id ?? this.id,
        );

    factory TranscriptTestSet.fromJson(Map<String, dynamic> json) => _$TranscriptTestSetFromJson(json);

    Map<String, dynamic> toJson() => _$TranscriptTestSetToJson(this);
}

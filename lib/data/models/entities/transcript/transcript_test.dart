// To parse this JSON data, do
//
//     final transcriptTest = transcriptTestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transcript_test.g.dart';

List<TranscriptTest> transcriptTestFromJson(String str) => List<TranscriptTest>.from(json.decode(str).map((x) => TranscriptTest.fromJson(x)));

String transcriptTestToJson(List<TranscriptTest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TranscriptTest {
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
    dynamic transcriptTestPart;
    @JsonKey(name: "id")
    String? id;

    TranscriptTest({
        this.title,
        this.url,
        this.attempts,
        this.code,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.transcriptTestPart,
        this.id,
    });

    TranscriptTest copyWith({
        String? title,
        String? url,
        List<dynamic>? attempts,
        String? code,
        String? description,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? image,
        dynamic transcriptTestPart,
        String? id,
    }) => 
        TranscriptTest(
            title: title ?? this.title,
            url: url ?? this.url,
            attempts: attempts ?? this.attempts,
            code: code ?? this.code,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            image: image ?? this.image,
            transcriptTestPart: transcriptTestPart ?? this.transcriptTestPart,
            id: id ?? this.id,
        );

    factory TranscriptTest.fromJson(Map<String, dynamic> json) => _$TranscriptTestFromJson(json);

    Map<String, dynamic> toJson() => _$TranscriptTestToJson(this);
}

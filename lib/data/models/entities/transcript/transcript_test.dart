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
    @JsonKey(name: "transcriptTestId")
    String? transcriptTestId;
    @JsonKey(name: "audioUrl")
    String? audioUrl;
    @JsonKey(name: "transcript")
    String? transcript;
    @JsonKey(name: "createdAt")
    DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt;
    @JsonKey(name: "id")
    String? id;

    TranscriptTest({
        this.transcriptTestId,
        this.audioUrl,
        this.transcript,
        this.createdAt,
        this.updatedAt,
        this.id,
    });

    TranscriptTest copyWith({
        String? transcriptTestId,
        String? audioUrl,
        String? transcript,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? id,
    }) => 
        TranscriptTest(
            transcriptTestId: transcriptTestId ?? this.transcriptTestId,
            audioUrl: audioUrl ?? this.audioUrl,
            transcript: transcript ?? this.transcript,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            id: id ?? this.id,
        );

    factory TranscriptTest.fromJson(Map<String, dynamic> json) => _$TranscriptTestFromJson(json);

    Map<String, dynamic> toJson() => _$TranscriptTestToJson(this);
}

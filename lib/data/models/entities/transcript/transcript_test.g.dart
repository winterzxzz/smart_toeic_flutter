// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptTest _$TranscriptTestFromJson(Map<String, dynamic> json) =>
    TranscriptTest(
      transcriptTestId: json['transcriptTestId'] as String?,
      audioUrl: json['audioUrl'] as String?,
      transcript: json['transcript'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TranscriptTestToJson(TranscriptTest instance) =>
    <String, dynamic>{
      'transcriptTestId': instance.transcriptTestId,
      'audioUrl': instance.audioUrl,
      'transcript': instance.transcript,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
    };

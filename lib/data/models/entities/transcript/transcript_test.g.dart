// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptTest _$TranscriptTestFromJson(Map<String, dynamic> json) =>
    TranscriptTest(
      title: json['title'] as String?,
      url: json['url'] as String?,
      attempts: json['attempts'] as List<dynamic>?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      image: json['image'] as String?,
      transcriptTestPart: json['part'],
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TranscriptTestToJson(TranscriptTest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'attempts': instance.attempts,
      'code': instance.code,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'image': instance.image,
      'part': instance.transcriptTestPart,
      'id': instance.id,
    };

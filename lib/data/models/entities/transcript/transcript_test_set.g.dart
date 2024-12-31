// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_test_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptTestSet _$TranscriptTestSetFromJson(Map<String, dynamic> json) =>
    TranscriptTestSet(
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
      transcriptTestSetPart: json['part'],
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TranscriptTestSetToJson(TranscriptTestSet instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'attempts': instance.attempts,
      'code': instance.code,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'image': instance.image,
      'part': instance.transcriptTestSetPart,
      'id': instance.id,
    };

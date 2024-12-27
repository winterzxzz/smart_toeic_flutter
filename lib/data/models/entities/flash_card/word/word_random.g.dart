// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_random.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordRandom _$WordRandomFromJson(Map<String, dynamic> json) => WordRandom(
      id: json['id'] as String?,
      word: json['word'] as String?,
      translation: json['translation'] as String?,
      description: json['description'] as String?,
      v: (json['__v'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WordRandomToJson(WordRandom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'translation': instance.translation,
      'description': instance.description,
      '__v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

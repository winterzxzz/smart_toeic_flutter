// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_set_flash_card_learning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewSetFlashCardLearning _$NewSetFlashCardLearningFromJson(
        Map<String, dynamic> json) =>
    NewSetFlashCardLearning(
      userId: json['userId'] as String?,
      setFlashcardId: json['setFlashcardId'] as String?,
      lastStudied: json['lastStudied'] == null
          ? null
          : DateTime.parse(json['lastStudied'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$NewSetFlashCardLearningToJson(
        NewSetFlashCardLearning instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'setFlashcardId': instance.setFlashcardId,
      'lastStudied': instance.lastStudied?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
    };

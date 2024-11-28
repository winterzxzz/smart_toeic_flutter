// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_flash_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningFlashCard _$LearningFlashCardFromJson(Map<String, dynamic> json) =>
    LearningFlashCard(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      setFlashcardId:
          FlashCard.fromJson(json['setFlashcardId'] as Map<String, dynamic>),
      lastStudied: DateTime.parse(json['lastStudied'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: (json['__v'] as num).toInt(),
      learningFlashcards: (json['learningFlashcards'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      learningFlashCardId: json['id'] as String,
    );

Map<String, dynamic> _$LearningFlashCardToJson(LearningFlashCard instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'setFlashcardId': instance.setFlashcardId,
      'lastStudied': instance.lastStudied.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.v,
      'learningFlashcards': instance.learningFlashcards,
      'id': instance.learningFlashCardId,
    };

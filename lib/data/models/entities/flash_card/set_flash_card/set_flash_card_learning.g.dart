// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_flash_card_learning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetFlashCardLearning _$SetFlashCardLearningFromJson(
        Map<String, dynamic> json) =>
    SetFlashCardLearning(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      setFlashcardId: SetFlashcardId.fromJson(
          json['setFlashcardId'] as Map<String, dynamic>),
      lastStudied: DateTime.parse(json['lastStudied'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: (json['__v'] as num).toInt(),
      learningFlashcards: (json['learningFlashcards'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      setFlashCardLearningId: json['id'] as String,
    );

Map<String, dynamic> _$SetFlashCardLearningToJson(
        SetFlashCardLearning instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'setFlashcardId': instance.setFlashcardId,
      'lastStudied': instance.lastStudied.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.v,
      'learningFlashcards': instance.learningFlashcards,
      'id': instance.setFlashCardLearningId,
    };

SetFlashcardId _$SetFlashcardIdFromJson(Map<String, dynamic> json) =>
    SetFlashcardId(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isPublic: json['isPublic'] as bool,
      userRole: json['userRole'] as String,
      numberOfFlashcards: (json['numberOfFlashcards'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: (json['__v'] as num).toInt(),
    );

Map<String, dynamic> _$SetFlashcardIdToJson(SetFlashcardId instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'userRole': instance.userRole,
      'numberOfFlashcards': instance.numberOfFlashcards,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.v,
    };

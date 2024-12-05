// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_flash_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetFlashCard _$SetFlashCardFromJson(Map<String, dynamic> json) => SetFlashCard(
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isPublic: json['isPublic'] as bool,
      userRole: json['userRole'] as String,
      numberOfFlashcards: (json['numberOfFlashcards'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$SetFlashCardToJson(SetFlashCard instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'userRole': instance.userRole,
      'numberOfFlashcards': instance.numberOfFlashcards,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };

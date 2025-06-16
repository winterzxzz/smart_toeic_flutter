// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCard _$FlashCardFromJson(Map<String, dynamic> json) => FlashCard(
      setFlashcardId: json['setFlashcardId'] as String?,
      word: json['word'] as String,
      translation: json['translation'] as String,
      definition: json['definition'] as String,
      exampleSentence: (json['exampleSentence'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      note: json['note'] as String,
      partOfSpeech: (json['partOfSpeech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pronunciation: json['pronunciation'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$FlashCardToJson(FlashCard instance) => <String, dynamic>{
      'setFlashcardId': instance.setFlashcardId,
      'word': instance.word,
      'translation': instance.translation,
      'definition': instance.definition,
      'exampleSentence': instance.exampleSentence,
      'note': instance.note,
      'partOfSpeech': instance.partOfSpeech,
      'pronunciation': instance.pronunciation,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };

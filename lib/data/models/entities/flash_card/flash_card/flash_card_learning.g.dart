// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_learning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardLearning _$FlashCardLearningFromJson(Map<String, dynamic> json) =>
    FlashCardLearning(
      flashcardId:
          FlashcardId.fromJson(json['flashcardId'] as Map<String, dynamic>),
      retentionScore: (json['retentionScore'] as num).toDouble(),
      decayScore: (json['decayScore'] as num).toDouble(),
      studyTime: (json['studyTime'] as num).toInt(),
      ef: (json['EF'] as num).toDouble(),
      learningSetId: json['learningSetId'] as String,
      optimalTime: json['optimalTime'] == null
          ? null
          : DateTime.parse(json['optimalTime'] as String),
      interval: (json['interval'] as num).toInt(),
      lastStudied: DateTime.parse(json['lastStudied'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$FlashCardLearningToJson(FlashCardLearning instance) =>
    <String, dynamic>{
      'flashcardId': instance.flashcardId,
      'retentionScore': instance.retentionScore,
      'decayScore': instance.decayScore,
      'studyTime': instance.studyTime,
      'EF': instance.ef,
      'learningSetId': instance.learningSetId,
      'optimalTime': instance.optimalTime?.toIso8601String(),
      'interval': instance.interval,
      'lastStudied': instance.lastStudied.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };

FlashcardId _$FlashcardIdFromJson(Map<String, dynamic> json) => FlashcardId(
      setFlashcardId: json['setFlashcardId'] as String,
      word: json['word'] as String,
      translation: json['translation'] as String,
      definition: json['definition'] as String,
      exampleSentence: (json['exampleSentence'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      note: json['note'] as String,
      partOfSpeech: (json['partOfSpeech'] as List<dynamic>)
          .map((e) => $enumDecode(_$PartOfSpeechEnumMap, e))
          .toList(),
      pronunciation: json['pronunciation'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$FlashcardIdToJson(FlashcardId instance) =>
    <String, dynamic>{
      'setFlashcardId': instance.setFlashcardId,
      'word': instance.word,
      'translation': instance.translation,
      'definition': instance.definition,
      'exampleSentence': instance.exampleSentence,
      'note': instance.note,
      'partOfSpeech':
          instance.partOfSpeech.map((e) => _$PartOfSpeechEnumMap[e]!).toList(),
      'pronunciation': instance.pronunciation,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };

const _$PartOfSpeechEnumMap = {
  PartOfSpeech.NOUN: 'noun',
  PartOfSpeech.VERB: 'verb',
};

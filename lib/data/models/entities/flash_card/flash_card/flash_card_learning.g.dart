// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_learning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardLearning _$FlashCardLearningFromJson(Map<String, dynamic> json) =>
    FlashCardLearning(
      flashcardId: json['flashcardId'] == null
          ? null
          : FlashCard.fromJson(json['flashcardId'] as Map<String, dynamic>),
      retentionScore: (json['retentionScore'] as num?)?.toDouble(),
      decayScore: (json['decayScore'] as num?)?.toDouble(),
      studyTime: (json['studyTime'] as num?)?.toInt(),
      ef: (json['EF'] as num?)?.toDouble(),
      learningSetId: json['learningSetId'] as String?,
      optimalTime: json['optimalTime'] == null
          ? null
          : DateTime.parse(json['optimalTime'] as String),
      interval: (json['interval'] as num?)?.toInt(),
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
      'lastStudied': instance.lastStudied?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
    };

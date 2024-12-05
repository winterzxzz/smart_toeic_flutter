// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_ai_gen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardAiGen _$FlashCardAiGenFromJson(Map<String, dynamic> json) =>
    FlashCardAiGen(
      definition: json['definition'] as String,
      example1: json['example1'] as String,
      example2: json['example2'] as String,
      note: json['note'] as String,
      partOfSpeech: (json['partOfSpeech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pronunciation: json['pronunciation'] as String,
      translation: json['translation'] as String,
      word: json['word'] as String,
    );

Map<String, dynamic> _$FlashCardAiGenToJson(FlashCardAiGen instance) =>
    <String, dynamic>{
      'definition': instance.definition,
      'example1': instance.example1,
      'example2': instance.example2,
      'note': instance.note,
      'partOfSpeech': instance.partOfSpeech,
      'pronunciation': instance.pronunciation,
      'translation': instance.translation,
      'word': instance.word,
    };

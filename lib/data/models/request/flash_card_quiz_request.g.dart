// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_quiz_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardQuizRequest _$FlashCardQuizRequestFromJson(
        Map<String, dynamic> json) =>
    FlashCardQuizRequest(
      prompt: (json['prompt'] as List<dynamic>)
          .map((e) => FlashCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlashCardQuizRequestToJson(
        FlashCardQuizRequest instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
    };

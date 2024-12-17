// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_explain_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionExplainRequest _$QuestionExplainRequestFromJson(
        Map<String, dynamic> json) =>
    QuestionExplainRequest(
      prompt: Question.fromJson(json['prompt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionExplainRequestToJson(
        QuestionExplainRequest instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
    };

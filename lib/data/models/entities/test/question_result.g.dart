// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionResult _$QuestionResultFromJson(Map<String, dynamic> json) =>
    QuestionResult(
      useranswer: json['useranswer'] as String,
      correctanswer: json['correctanswer'] as String,
      userId: json['userId'] as String,
      questionNum: json['questionNum'] as String,
      testId: json['testId'] as String,
      testType: json['testType'] as String,
      resultId: json['resultId'] as String,
      questionResultPart: (json['part'] as num).toInt(),
      isReading: json['isReading'] as bool,
      timeSecond: (json['timeSecond'] as num).toInt(),
      questionCategory: json['questionCategory'] as List<dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$QuestionResultToJson(QuestionResult instance) =>
    <String, dynamic>{
      'useranswer': instance.useranswer,
      'correctanswer': instance.correctanswer,
      'userId': instance.userId,
      'questionNum': instance.questionNum,
      'testId': instance.testId,
      'testType': instance.testType,
      'resultId': instance.resultId,
      'part': instance.questionResultPart,
      'isReading': instance.isReading,
      'timeSecond': instance.timeSecond,
      'questionCategory': instance.questionCategory,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_test_submit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultTestSubmit _$ResultTestSubmitFromJson(Map<String, dynamic> json) =>
    ResultTestSubmit(
      userId: json['userId'] as String,
      testId: json['testId'] as String,
      testType: json['testType'] as String,
      numberOfQuestions: (json['numberOfQuestions'] as num).toInt(),
      numberOfUserAnswers: (json['numberOfUserAnswers'] as num).toInt(),
      numberOfCorrectAnswers: (json['numberOfCorrectAnswers'] as num).toInt(),
      secondTime: (json['secondTime'] as num).toInt(),
      parts: json['parts'] as List<dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$ResultTestSubmitToJson(ResultTestSubmit instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'testId': instance.testId,
      'testType': instance.testType,
      'numberOfQuestions': instance.numberOfQuestions,
      'numberOfUserAnswers': instance.numberOfUserAnswers,
      'numberOfCorrectAnswers': instance.numberOfCorrectAnswers,
      'secondTime': instance.secondTime,
      'parts': instance.parts,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
    };

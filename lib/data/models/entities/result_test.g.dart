// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultTest _$ResultTestFromJson(Map<String, dynamic> json) => ResultTest(
      userId: json['userId'] as String,
      testId: TestId.fromJson(json['testId'] as Map<String, dynamic>),
      testType: json['testType'] as String,
      numberOfQuestions: (json['numberOfQuestions'] as num).toInt(),
      numberOfUserAnswers: (json['numberOfUserAnswers'] as num).toInt(),
      numberOfCorrectAnswers: (json['numberOfCorrectAnswers'] as num).toInt(),
      secondTime: (json['secondTime'] as num).toInt(),
      parts: (json['parts'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$ResultTestToJson(ResultTest instance) =>
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

TestId _$TestIdFromJson(Map<String, dynamic> json) => TestId(
      title: json['title'] as String,
      type: json['type'] as String,
      attempts: (json['attempts'] as List<dynamic>)
          .map((e) => Attempt.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as String,
      numberOfQuestions: (json['numberOfQuestions'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      duration: (json['duration'] as num).toInt(),
      fileName: json['fileName'] as String,
      parts: (json['parts'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      numberOfParts: (json['numberOfParts'] as num).toInt(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$TestIdToJson(TestId instance) => <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'attempts': instance.attempts,
      'code': instance.code,
      'numberOfQuestions': instance.numberOfQuestions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'duration': instance.duration,
      'fileName': instance.fileName,
      'parts': instance.parts,
      'numberOfParts': instance.numberOfParts,
      'id': instance.id,
    };

Attempt _$AttemptFromJson(Map<String, dynamic> json) => Attempt(
      userId: json['userId'] as String,
      times: (json['times'] as num).toInt(),
    );

Map<String, dynamic> _$AttemptToJson(Attempt instance) => <String, dynamic>{
      'userId': instance.userId,
      'times': instance.times,
    };

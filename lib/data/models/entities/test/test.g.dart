// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Test _$TestFromJson(Map<String, dynamic> json) => Test(
      title: json['title'] as String?,
      type: json['type'] as String?,
      numberOfParts: (json['numberOfParts'] as num?)?.toInt(),
      code: json['code'] as String?,
      numberOfQuestions: (json['numberOfQuestions'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isPublished: json['isPublished'] as bool?,
      difficulty: json['difficulty'] as String?,
      attemptCount: (json['attemptCount'] as num?)?.toInt(),
      userAttempt: json['userAttempt'] == null
          ? null
          : UserAttempt.fromJson(json['userAttempt'] as Map<String, dynamic>),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'numberOfParts': instance.numberOfParts,
      'code': instance.code,
      'numberOfQuestions': instance.numberOfQuestions,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'duration': instance.duration,
      'parts': instance.parts,
      'isPublished': instance.isPublished,
      'difficulty': instance.difficulty,
      'attemptCount': instance.attemptCount,
      'userAttempt': instance.userAttempt,
      'id': instance.id,
    };

UserAttempt _$UserAttemptFromJson(Map<String, dynamic> json) => UserAttempt(
      count: (json['count'] as num?)?.toInt(),
      lastTime: json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String),
    );

Map<String, dynamic> _$UserAttemptToJson(UserAttempt instance) =>
    <String, dynamic>{
      'count': instance.count,
      'lastTime': instance.lastTime?.toIso8601String(),
    };

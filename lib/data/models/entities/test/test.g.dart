// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Test _$TestFromJson(Map<String, dynamic> json) => Test(
      title: json['title'] as String?,
      type: json['type'] as String?,
      code: json['code'] as String?,
      numberOfQuestions: (json['numberOfQuestions'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      attemptCount: (json['attemptCount'] as num?)?.toInt(),
      userAttempt: json['userAttempt'] == null
          ? null
          : UserAttempt.fromJson(json['userAttempt'] as Map<String, dynamic>),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'code': instance.code,
      'numberOfQuestions': instance.numberOfQuestions,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'duration': instance.duration,
      'attemptCount': instance.attemptCount,
      'userAttempt': instance.userAttempt,
      'id': instance.id,
    };

UserAttempt _$UserAttemptFromJson(Map<String, dynamic> json) => UserAttempt(
      count: (json['count'] as num?)?.toInt(),
      lastTime: json['lastTime'],
    );

Map<String, dynamic> _$UserAttemptToJson(UserAttempt instance) =>
    <String, dynamic>{
      'count': instance.count,
      'lastTime': instance.lastTime,
    };

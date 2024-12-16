// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      avatar: json['avatar'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      accountType: json['accountType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      googleId: json['googleId'] as String?,
      role: json['role'] as String,
      upgradeExpiredDate: json['upgradeExpiredDate'] as String?,
      targetScore: json['targetScore'] == null
          ? null
          : TargetScore.fromJson(json['targetScore'] as Map<String, dynamic>),
      bio: json['bio'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'email': instance.email,
      'name': instance.name,
      'status': instance.status,
      'accountType': instance.accountType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'googleId': instance.googleId,
      'role': instance.role,
      'upgradeExpiredDate': instance.upgradeExpiredDate,
      'targetScore': instance.targetScore,
      'bio': instance.bio,
      'id': instance.id,
    };

TargetScore _$TargetScoreFromJson(Map<String, dynamic> json) => TargetScore(
      reading: (json['reading'] as num).toInt(),
      listening: (json['listening'] as num).toInt(),
    );

Map<String, dynamic> _$TargetScoreToJson(TargetScore instance) =>
    <String, dynamic>{
      'reading': instance.reading,
      'listening': instance.listening,
    };

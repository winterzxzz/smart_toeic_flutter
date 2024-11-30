// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      email: json['email'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      accountType: json['accountType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      googleId: json['googleId'] as String?,
      role: json['role'] as String,
      upgradeExpiredDate: json['upgradeExpiredDate'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'status': instance.status,
      'accountType': instance.accountType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'googleId': instance.googleId,
      'role': instance.role,
      'upgradeExpiredDate': instance.upgradeExpiredDate,
      'id': instance.id,
    };

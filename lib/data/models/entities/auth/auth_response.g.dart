// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSuccess _$AuthSuccessFromJson(Map<String, dynamic> json) => AuthSuccess(
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthSuccessToJson(AuthSuccess instance) =>
    <String, dynamic>{
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

AuthChallenge _$AuthChallengeFromJson(Map<String, dynamic> json) =>
    AuthChallenge(
      user: AuthUserChallenge.fromJson(json['user'] as Map<String, dynamic>),
      requiresEmailConfirmation: json['requiresEmailConfirmation'] as bool,
      message: json['message'] as String,
      securityAlert: json['securityAlert'] == null
          ? null
          : SecurityAlert.fromJson(
              json['securityAlert'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthChallengeToJson(AuthChallenge instance) =>
    <String, dynamic>{
      'user': instance.user,
      'requiresEmailConfirmation': instance.requiresEmailConfirmation,
      'message': instance.message,
      'securityAlert': instance.securityAlert,
    };

AuthUserChallenge _$AuthUserChallengeFromJson(Map<String, dynamic> json) =>
    AuthUserChallenge(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$AuthUserChallengeToJson(AuthUserChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
    };

SecurityAlert _$SecurityAlertFromJson(Map<String, dynamic> json) =>
    SecurityAlert(
      message: json['message'] as String,
      riskLevel: json['riskLevel'] as String,
    );

Map<String, dynamic> _$SecurityAlertToJson(SecurityAlert instance) =>
    <String, dynamic>{
      'message': instance.message,
      'riskLevel': instance.riskLevel,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiChatSession _$AiChatSessionFromJson(Map<String, dynamic> json) =>
    AiChatSession(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      modelName: json['modelName'] as String,
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: (json['__v'] as num).toInt(),
    );

Map<String, dynamic> _$AiChatSessionToJson(AiChatSession instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'modelName': instance.modelName,
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.v,
    };

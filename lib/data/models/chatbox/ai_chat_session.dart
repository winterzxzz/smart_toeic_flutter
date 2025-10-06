// To parse this JSON data, do
//
//     final aiChatSession = aiChatSessionFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'ai_chat_session.g.dart';

List<AiChatSession> aiChatSessionFromJson(String str) => List<AiChatSession>.from(json.decode(str).map((x) => AiChatSession.fromJson(x)));

String aiChatSessionToJson(List<AiChatSession> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AiChatSession {
    @JsonKey(name: "_id")
    final String id;
    @JsonKey(name: "userId")
    final String userId;
    @JsonKey(name: "title")
    final String title;
    @JsonKey(name: "modelName")
    final String modelName;
    @JsonKey(name: "lastMessageAt")
    final DateTime lastMessageAt;
    @JsonKey(name: "createdAt")
    final DateTime createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime updatedAt;
    @JsonKey(name: "__v")
    final int v;

    AiChatSession({
        required this.id,
        required this.userId,
        required this.title,
        required this.modelName,
        required this.lastMessageAt,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    AiChatSession copyWith({
        String? id,
        String? userId,
        String? title,
        String? modelName,
        DateTime? lastMessageAt,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
    }) => 
        AiChatSession(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            title: title ?? this.title,
            modelName: modelName ?? this.modelName,
            lastMessageAt: lastMessageAt ?? this.lastMessageAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
        );

    factory AiChatSession.fromJson(Map<String, dynamic> json) => _$AiChatSessionFromJson(json);

    Map<String, dynamic> toJson() => _$AiChatSessionToJson(this);
}

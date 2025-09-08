// To parse this JSON data, do
//
//     final roomDb = roomDbFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'room_db.g.dart';

RoomDb roomDbFromJson(String str) => RoomDb.fromJson(json.decode(str));

String roomDbToJson(RoomDb data) => json.encode(data.toJson());

@JsonSerializable()
class RoomDb {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "slug")
  final String slug;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "thumbnail")
  final String thumbnail;
  @JsonKey(name: "liverId")
  final int liverId;
  @JsonKey(name: "livekitSid")
  final dynamic livekitSid;
  @JsonKey(name: "status")
  final String status;
  @JsonKey(name: "process")
  final String process;
  @JsonKey(name: "maxParticipants")
  final dynamic maxParticipants;
  @JsonKey(name: "viewers")
  final int viewers;
  @JsonKey(name: "highestConcurrentViewers")
  final int highestConcurrentViewers;
  @JsonKey(name: "numberOfUniqueUsers")
  final int numberOfUniqueUsers;
  @JsonKey(name: "startedAt")
  final dynamic startedAt;
  @JsonKey(name: "finishedAt")
  final dynamic finishedAt;
  @JsonKey(name: "createdAt")
  final DateTime createdAt;
  @JsonKey(name: "updatedAt")
  final DateTime updatedAt;
  @JsonKey(name: "deletedAt")
  final dynamic deletedAt;
  @JsonKey(name: "liver")
  final Liver liver;

  RoomDb({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.liverId,
    required this.livekitSid,
    required this.status,
    required this.process,
    required this.maxParticipants,
    required this.viewers,
    required this.highestConcurrentViewers,
    required this.numberOfUniqueUsers,
    required this.startedAt,
    required this.finishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.liver,
  });

  RoomDb copyWith({
    int? id,
    String? slug,
    String? name,
    String? description,
    String? thumbnail,
    int? liverId,
    dynamic livekitSid,
    String? status,
    String? process,
    dynamic maxParticipants,
    int? viewers,
    int? highestConcurrentViewers,
    int? numberOfUniqueUsers,
    dynamic startedAt,
    dynamic finishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    Liver? liver,
  }) =>
      RoomDb(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        description: description ?? this.description,
        thumbnail: thumbnail ?? this.thumbnail,
        liverId: liverId ?? this.liverId,
        livekitSid: livekitSid ?? this.livekitSid,
        status: status ?? this.status,
        process: process ?? this.process,
        maxParticipants: maxParticipants ?? this.maxParticipants,
        viewers: viewers ?? this.viewers,
        highestConcurrentViewers:
            highestConcurrentViewers ?? this.highestConcurrentViewers,
        numberOfUniqueUsers: numberOfUniqueUsers ?? this.numberOfUniqueUsers,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt ?? this.finishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        liver: liver ?? this.liver,
      );

  factory RoomDb.fromJson(Map<String, dynamic> json) => _$RoomDbFromJson(json);

  Map<String, dynamic> toJson() => _$RoomDbToJson(this);
}

@JsonSerializable()
class Liver {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "username")
  final String username;
  @JsonKey(name: "avatarUrl")
  final String avatarUrl;

  Liver({
    required this.id,
    required this.username,
    required this.avatarUrl,
  });

  Liver copyWith({
    int? id,
    String? username,
    String? avatarUrl,
  }) =>
      Liver(
        id: id ?? this.id,
        username: username ?? this.username,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  factory Liver.fromJson(Map<String, dynamic> json) => _$LiverFromJson(json);

  Map<String, dynamic> toJson() => _$LiverToJson(this);
}

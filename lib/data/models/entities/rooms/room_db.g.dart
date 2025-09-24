// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_db.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomDb _$RoomDbFromJson(Map<String, dynamic> json) => RoomDb(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      liverId: json['liverId'] as String,
      status: json['status'] as String,
      process: json['process'] as String,
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      viewers: (json['viewers'] as num).toInt(),
      highestConcurrentViewers:
          (json['highestConcurrentViewers'] as num).toInt(),
      numberOfUniqueUsers: (json['numberOfUniqueUsers'] as num).toInt(),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      finishedAt: json['finishedAt'] == null
          ? null
          : DateTime.parse(json['finishedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      liver: Liver.fromJson(json['liver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoomDbToJson(RoomDb instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'liverId': instance.liverId,
      'status': instance.status,
      'process': instance.process,
      'maxParticipants': instance.maxParticipants,
      'viewers': instance.viewers,
      'highestConcurrentViewers': instance.highestConcurrentViewers,
      'numberOfUniqueUsers': instance.numberOfUniqueUsers,
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'liver': instance.liver,
    };

Liver _$LiverFromJson(Map<String, dynamic> json) => Liver(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$LiverToJson(Liver instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
    };

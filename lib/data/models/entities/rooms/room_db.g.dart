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
      liverId: (json['liverId'] as num).toInt(),
      livekitSid: json['livekitSid'],
      status: json['status'] as String,
      process: json['process'] as String,
      maxParticipants: json['maxParticipants'],
      viewers: (json['viewers'] as num).toInt(),
      highestConcurrentViewers:
          (json['highestConcurrentViewers'] as num).toInt(),
      numberOfUniqueUsers: (json['numberOfUniqueUsers'] as num).toInt(),
      startedAt: json['startedAt'],
      finishedAt: json['finishedAt'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'],
      liver: Liver.fromJson(json['liver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoomDbToJson(RoomDb instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'liverId': instance.liverId,
      'livekitSid': instance.livekitSid,
      'status': instance.status,
      'process': instance.process,
      'maxParticipants': instance.maxParticipants,
      'viewers': instance.viewers,
      'highestConcurrentViewers': instance.highestConcurrentViewers,
      'numberOfUniqueUsers': instance.numberOfUniqueUsers,
      'startedAt': instance.startedAt,
      'finishedAt': instance.finishedAt,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt,
      'liver': instance.liver,
    };

Liver _$LiverFromJson(Map<String, dynamic> json) => Liver(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$LiverToJson(Liver instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
    };

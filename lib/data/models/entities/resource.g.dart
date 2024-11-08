// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      ext: json['ext'] as String,
      pin: json['pin'] as String?,
      path: json['path'] as String,
      level: (json['level'] as num).toInt(),
      parentId: json['parent_id'] as String?,
      size: (json['size'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'ext': instance.ext,
      'pin': instance.pin,
      'path': instance.path,
      'level': instance.level,
      'parent_id': instance.parentId,
      'size': instance.size,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

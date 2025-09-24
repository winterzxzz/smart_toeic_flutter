// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_room_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRoomRequest _$CreateRoomRequestFromJson(Map<String, dynamic> json) =>
    CreateRoomRequest(
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$CreateRoomRequestToJson(CreateRoomRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
    };

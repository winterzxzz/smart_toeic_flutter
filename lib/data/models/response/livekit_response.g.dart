// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livekit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivekitResponse _$LivekitResponseFromJson(Map<String, dynamic> json) =>
    LivekitResponse(
      room: json['room'] as String,
      sid: json['sid'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$LivekitResponseToJson(LivekitResponse instance) =>
    <String, dynamic>{
      'room': instance.room,
      'sid': instance.sid,
      'token': instance.token,
    };

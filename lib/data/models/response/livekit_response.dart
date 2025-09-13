// To parse this JSON data, do
//
//     final livekitResponse = livekitResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'livekit_response.g.dart';

LivekitResponse livekitResponseFromJson(String str) => LivekitResponse.fromJson(json.decode(str));

String livekitResponseToJson(LivekitResponse data) => json.encode(data.toJson());

@JsonSerializable()
class LivekitResponse {
    @JsonKey(name: "room")
    final String room;
    @JsonKey(name: "sid")
    final String sid;
    @JsonKey(name: "token")
    final String token;

    LivekitResponse({
        required this.room,
        required this.sid,
        required this.token,
    });

    LivekitResponse copyWith({
        String? room,
        String? sid,
        String? token,
    }) => 
        LivekitResponse(
            room: room ?? this.room,
            sid: sid ?? this.sid,
            token: token ?? this.token,
        );

    factory LivekitResponse.fromJson(Map<String, dynamic> json) => _$LivekitResponseFromJson(json);

    Map<String, dynamic> toJson() => _$LivekitResponseToJson(this);
}

// To parse this JSON data, do
//
//     final createRoomRequest = createRoomRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'create_room_request.g.dart';

CreateRoomRequest createRoomRequestFromJson(String str) =>
    CreateRoomRequest.fromJson(json.decode(str));

String createRoomRequestToJson(CreateRoomRequest data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CreateRoomRequest {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "thumbnail")
  final String thumbnail;

  CreateRoomRequest({
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  CreateRoomRequest copyWith({
    String? name,
    String? description,
    String? thumbnail,
  }) =>
      CreateRoomRequest(
        name: name ?? this.name,
        description: description ?? this.description,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory CreateRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoomRequestToJson(this);
}

// To parse this JSON data, do
//
//     final profileUpdateRequest = profileUpdateRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'profile_update_request.g.dart';

ProfileUpdateRequest profileUpdateRequestFromJson(String str) => ProfileUpdateRequest.fromJson(json.decode(str));

String profileUpdateRequestToJson(ProfileUpdateRequest data) => json.encode(data.toJson());

@JsonSerializable()
class ProfileUpdateRequest {
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "bio")
    String bio;

    ProfileUpdateRequest({
        required this.name,
        required this.bio,
    });

    factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) => _$ProfileUpdateRequestFromJson(json);

    Map<String, dynamic> toJson() => _$ProfileUpdateRequestToJson(this);
}

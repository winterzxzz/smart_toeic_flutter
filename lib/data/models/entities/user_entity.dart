// To parse this JSON data, do
//
//     final userEntity = userEntityFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_entity.g.dart';

UserEntity userEntityFromJson(String str) => UserEntity.fromJson(json.decode(str));

String userEntityToJson(UserEntity data) => json.encode(data.toJson());

@JsonSerializable()
class UserEntity {
    @JsonKey(name: "email")
    String email;
    @JsonKey(name: "password")
    String password;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "status")
    String status;
    @JsonKey(name: "accountType")
    String accountType;
    @JsonKey(name: "role")
    String role;
    @JsonKey(name: "createdAt")
    DateTime createdAt;
    @JsonKey(name: "updatedAt")
    DateTime updatedAt;
    @JsonKey(name: "id")
    String id;

    UserEntity({
        required this.email,
        required this.password,
        required this.name,
        required this.status,
        required this.accountType,
        required this.role,
        required this.createdAt,
        required this.updatedAt,
        required this.id,
    });

    factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

    Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

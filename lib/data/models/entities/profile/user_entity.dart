// To parse this JSON data, do
//
//     final userEntity = userEntityFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_entity.g.dart';

UserEntity userEntityFromJson(String str) =>
    UserEntity.fromJson(json.decode(str));

String userEntityToJson(UserEntity data) => json.encode(data.toJson());

@JsonSerializable()
class UserEntity {
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "accountType")
  String accountType;
  @JsonKey(name: "createdAt")
  DateTime createdAt;
  @JsonKey(name: "updatedAt")
  DateTime updatedAt;
  @JsonKey(name: "googleId")
  String? googleId;
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "upgradeExpiredDate")
  String? upgradeExpiredDate;
  @JsonKey(name: "id")
  String id;

  UserEntity({
    required this.email,
    required this.name,
    required this.status,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
    this.googleId,
    required this.role,
    this.upgradeExpiredDate,
    required this.id,
  });

  bool isPremium() {
    if (upgradeExpiredDate == null) return false;
    return DateTime.parse(upgradeExpiredDate!).isAfter(DateTime.now());
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

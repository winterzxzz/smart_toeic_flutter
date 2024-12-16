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
  @JsonKey(name: "avatar")
  String avatar;
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
  @JsonKey(name: "targetScore")
  TargetScore? targetScore;
  @JsonKey(name: "bio")
  String bio;
  @JsonKey(name: "id")
  String id;

  UserEntity({
    required this.avatar,
    required this.email,
    required this.name,
    required this.status,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
    this.googleId,
    required this.role,
    this.upgradeExpiredDate,
    this.targetScore,
    required this.bio,
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

@JsonSerializable()
class TargetScore {
  @JsonKey(name: "reading")
  int reading;
  @JsonKey(name: "listening")
  int listening;

  TargetScore({
    required this.reading,
    required this.listening,
  });

  factory TargetScore.fromJson(Map<String, dynamic> json) =>
      _$TargetScoreFromJson(json);

  Map<String, dynamic> toJson() => _$TargetScoreToJson(this);
}

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
  @JsonKey(name: "actualScore")
  TargetScore? actualScore;
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
    this.actualScore,
    required this.bio,
    required this.id,
  });

  bool isPremium() {
    if (upgradeExpiredDate == null) return false;
    return DateTime.parse(upgradeExpiredDate!).isAfter(DateTime.now());
  }

  // copyWith
  UserEntity copyWith({
    String? avatar,
    String? email,
    String? name,
    String? status,
    String? accountType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? googleId,
    String? role,
    String? upgradeExpiredDate,
    TargetScore? targetScore,
    TargetScore? actualScore,
    String? bio,
    String? id,
  }) {
    return UserEntity(
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      name: name ?? this.name,
      status: status ?? this.status,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      googleId: googleId ?? this.googleId,
      role: role ?? this.role,
      upgradeExpiredDate: upgradeExpiredDate ?? this.upgradeExpiredDate,
      targetScore: targetScore ?? this.targetScore,
      actualScore: actualScore ?? this.actualScore,
      bio: bio ?? this.bio,
      id: id ?? this.id,
    );
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

// To parse this JSON data, do
//
//     final setFlashCard = setFlashCardFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'set_flash_card.g.dart';

List<SetFlashCard> setFlashCardFromJson(String str) => List<SetFlashCard>.from(
    json.decode(str).map((x) => SetFlashCard.fromJson(x)));

String setFlashCardToJson(List<SetFlashCard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class SetFlashCard {
  @JsonKey(name: "userId")
  String userId;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "isPublic")
  bool isPublic;
  @JsonKey(name: "userRole")
  String userRole;
  @JsonKey(name: "numberOfFlashcards")
  int numberOfFlashcards;
  @JsonKey(name: "createdAt")
  DateTime createdAt;
  @JsonKey(name: "updatedAt")
  DateTime updatedAt;
  @JsonKey(name: "id")
  String id;

  SetFlashCard({
    required this.userId,
    required this.title,
    required this.description,
    required this.isPublic,
    required this.userRole,
    required this.numberOfFlashcards,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  // copy with
  SetFlashCard copyWith({
    String? userId,
    String? title,
    String? description,
    bool? isPublic,
    String? userRole,
    int? numberOfFlashcards,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
  }) {
    return SetFlashCard(
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      userRole: userRole ?? this.userRole,
      numberOfFlashcards: numberOfFlashcards ?? this.numberOfFlashcards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }

  factory SetFlashCard.fromJson(Map<String, dynamic> json) =>
      _$SetFlashCardFromJson(json);

  Map<String, dynamic> toJson() => _$SetFlashCardToJson(this);
}

// To parse this JSON data, do
//
//     final blog = blogFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'blog.g.dart';

List<Blog> blogFromJson(String str) =>
    List<Blog>.from(json.decode(str).map((x) => Blog.fromJson(x)));

String blogToJson(List<Blog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Blog {
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "author")
  String? author;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "view")
  int? view;
  @JsonKey(name: "category")
  String? category;
  @JsonKey(name: "isPublished")
  bool? isPublished;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "id")
  String? id;

  Blog({
    this.title,
    this.description,
    this.content,
    this.author,
    this.image,
    this.view,
    this.category,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  Blog copyWith({
    String? title,
    String? description,
    String? content,
    String? author,
    String? image,
    int? view,
    String? category,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
  }) =>
      Blog(
        title: title ?? this.title,
        description: description ?? this.description,
        content: content ?? this.content,
        author: author ?? this.author,
        image: image ?? this.image,
        view: view ?? this.view,
        category: category ?? this.category,
        isPublished: isPublished ?? this.isPublished,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        id: id ?? this.id,
      );

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  Map<String, dynamic> toJson() => _$BlogToJson(this);
}

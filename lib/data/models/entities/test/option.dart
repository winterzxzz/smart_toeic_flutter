// To parse this JSON data, do
//
//     final option = optionFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'option.g.dart';

Option optionFromJson(String str) => Option.fromJson(json.decode(str));

String optionToJson(Option data) => json.encode(data.toJson());

@JsonSerializable()
class Option {
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "content")
    String content;

    Option({
        required this.id,
        required this.content,
    });

    factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

    Map<String, dynamic> toJson() => _$OptionToJson(this);
}

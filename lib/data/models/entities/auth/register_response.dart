import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: "key")
  String key;

  RegisterResponse({
    required this.key,
  });

  RegisterResponse copyWith({
    String? key,
  }) =>
      RegisterResponse(
        key: key ?? this.key,
      );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

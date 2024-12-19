// To parse this JSON data, do
//
//     final apiError = apiErrorFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'api_error.g.dart';

ApiError apiErrorFromJson(String str) => ApiError.fromJson(json.decode(str));

String apiErrorToJson(ApiError data) => json.encode(data.toJson());

@JsonSerializable()
class ApiError {
    @JsonKey(name: "errors")
    final List<Error>? errors;

    ApiError({
        this.errors,
    });

    factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);

    Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

@JsonSerializable()
class Error {
    @JsonKey(name: "message")
    final String? message;

    Error({
        this.message,
    });

    factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

    Map<String, dynamic> toJson() => _$ErrorToJson(this);
}

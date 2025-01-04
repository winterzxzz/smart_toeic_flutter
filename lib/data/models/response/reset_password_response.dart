// To parse this JSON data, do
//
//     final resetPasswordResponse = resetPasswordResponseFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'reset_password_response.g.dart';

ResetPasswordResponse resetPasswordResponseFromJson(String str) => ResetPasswordResponse.fromJson(json.decode(str));

String resetPasswordResponseToJson(ResetPasswordResponse data) => json.encode(data.toJson());

@JsonSerializable()
class ResetPasswordResponse {
    @JsonKey(name: "status")
    int? status;
    @JsonKey(name: "message")
    String? message;

    ResetPasswordResponse({
        this.status,
        this.message,
    });

    ResetPasswordResponse copyWith({
        int? status,
        String? message,
    }) => 
        ResetPasswordResponse(
            status: status ?? this.status,
            message: message ?? this.message,
        );

    factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) => _$ResetPasswordResponseFromJson(json);

    Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}

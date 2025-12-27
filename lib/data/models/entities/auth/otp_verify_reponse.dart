import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'otp_verify_reponse.g.dart';

@JsonSerializable()
class OtpVerifyReponse {
  @JsonKey(name: "key")
  String key;
  @JsonKey(name: "email")
  String email;

  OtpVerifyReponse({
    required this.key,
    required this.email,
  });

  OtpVerifyReponse copyWith({
    String? key,
    String? email,
  }) =>
      OtpVerifyReponse(
        key: key ?? this.key,
        email: email ?? this.email,
      );

  factory OtpVerifyReponse.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyReponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyReponseToJson(this);
}

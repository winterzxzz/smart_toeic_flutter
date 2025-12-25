import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: "user")
  User user;
  @JsonKey(name: "accessToken")
  String accessToken;
  @JsonKey(name: "refreshToken")
  String refreshToken;

  RegisterResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  RegisterResponse copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
  }) =>
      RegisterResponse(
        user: user ?? this.user,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "name")
  String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

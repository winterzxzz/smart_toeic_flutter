import 'package:json_annotation/json_annotation.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';

part 'auth_response.g.dart';

// --- ROOT CLASS (SEALED) ---
sealed class AuthResponse {
  AuthResponse();

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // LOGIC BẠN YÊU CẦU:
    // Kiểm tra xem key 'requiresEmailConfirmation' có tồn tại và khác null không
    if (json['requiresEmailConfirmation'] != null) {
      return AuthChallenge.fromJson(json);
    } else {
      // Mặc định nếu không phải challenge thì là login thành công
      return AuthSuccess.fromJson(json);
    }
  }
}

// --- CASE 1: LOGIN THÀNH CÔNG (Response 2) ---
@JsonSerializable()
class AuthSuccess extends AuthResponse {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  AuthSuccess({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSuccess.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessFromJson(json);
}

// --- CASE 2: CẦN XÁC THỰC / UNUSUAL ACTIVITY (Response 1) ---
@JsonSerializable()
class AuthChallenge extends AuthResponse {
  final AuthUserChallenge user;
  final bool requiresEmailConfirmation;
  final String message;
  final SecurityAlert? securityAlert;

  AuthChallenge({
    required this.user,
    required this.requiresEmailConfirmation,
    required this.message,
    this.securityAlert,
  });

  factory AuthChallenge.fromJson(Map<String, dynamic> json) =>
      _$AuthChallengeFromJson(json);
}

@JsonSerializable()
class AuthUserChallenge {
  @JsonKey(name: 'id') // Lưu ý: JSON này trả về id (không có _)
  final String id;
  final String email;
  final String name;
  final String? avatar;

  AuthUserChallenge(
      {required this.id, required this.email, required this.name, this.avatar});

  factory AuthUserChallenge.fromJson(Map<String, dynamic> json) =>
      _$AuthUserChallengeFromJson(json);
}

@JsonSerializable()
class SecurityAlert {
  final String message;
  final String riskLevel;

  SecurityAlert({required this.message, required this.riskLevel});

  factory SecurityAlert.fromJson(Map<String, dynamic> json) =>
      _$SecurityAlertFromJson(json);
}

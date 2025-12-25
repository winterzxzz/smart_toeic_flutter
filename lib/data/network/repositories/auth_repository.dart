import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/auth/auth_response.dart';
import 'package:toeic_desktop/data/models/entities/auth/register_response.dart';
import 'package:toeic_desktop/data/models/response/reset_password_response.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class AuthRepository {
  Future<Either<ApiError, AuthResponse>> login(String email, String password);

  Future<Either<ApiError, RegisterResponse>> signUp({
    required String email,
    required String name,
    required String password,
  });

  Future<Either<ApiError, ResetPasswordResponse>> resetPassword(String email);

  Future<Either<ApiError, AuthResponse>> confirmLogin(String tokenId);
}

class AuthRepositoryImpl extends AuthRepository {
  ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<Either<ApiError, AuthResponse>> login(
      String email, String password) async {
    try {
      final result = await apiClient.login(email, password);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, RegisterResponse>> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final result = await apiClient.signUp(email, name, password);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, ResetPasswordResponse>> resetPassword(
      String email) async {
    try {
      final result = await apiClient.resetPassword(email);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, AuthResponse>> confirmLogin(String tokenId) async {
    try {
      final result = await apiClient.confirmLogin(tokenId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}

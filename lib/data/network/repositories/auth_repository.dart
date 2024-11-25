import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/user_entity.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class AuthRepository {
  Future<Either<ApiError, UserEntity>> login(String email, String password);

  Future<Either<ApiError, UserEntity?>> signUp({
    required String email,
    required String name,
    required String password,
  });
}

class AuthRepositoryImpl extends AuthRepository {
  ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<Either<ApiError, UserEntity>> login(
      String email, String password) async {
    try {
      final result = await apiClient.login(email, password);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, UserEntity>> signUp({
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
}

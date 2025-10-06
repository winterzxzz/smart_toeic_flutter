import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class ChatAiRepository {
  Future<Either<ApiError, String>> createAiChatSession(String title);
  Future<Either<ApiError, String>> sendAiChatMessage({
    required String sessionId,
    required String content,
    required String socketId,
  });
  Future<Either<ApiError, String>> getAiChatHistory(String sessionId);
  Future<Either<ApiError, void>> deleteAiChatHistory(String sessionId);
}

class ChatAiRepositoryImpl extends ChatAiRepository {
  final ApiClient _apiClient;

  ChatAiRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiError, String>> createAiChatSession(String title) async {
    try {
      final response = await _apiClient.createAiChatSession(title);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteAiChatHistory(String sessionId) async {
    try {
      await _apiClient.deleteAiChatHistory(sessionId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, String>> getAiChatHistory(String sessionId) async {
    try {
      final response = await _apiClient.getAiChatHistory(sessionId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override 
  Future<Either<ApiError, String>> sendAiChatMessage({
    required String sessionId,
    required String content,
    required String socketId,
  }) async {
    try {
      final response = await _apiClient.sendAiChatMessage(sessionId, content, socketId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}

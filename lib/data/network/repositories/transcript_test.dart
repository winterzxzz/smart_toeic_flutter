
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class TranscriptTestRepository {
  Future<Either<ApiError, List<TranscriptTest>>> getTranscriptTest();
}

class TranscriptTestRepositoryImpl extends TranscriptTestRepository {
  final ApiClient _apiClient;

  TranscriptTestRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiError, List<TranscriptTest>>> getTranscriptTest() async {
    try {
      final response = await _apiClient.getTranscriptTest();
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }
}

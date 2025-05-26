

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test_set.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class TranscriptTestRepository {
  Future<Either<ApiError, List<TranscriptTestSet>>> getTranscriptTestSets();
  Future<Either<ApiError, List<TranscriptTest>>> getTranscriptTestDetail(String transcriptTestId);
}

class TranscriptTestRepositoryImpl extends TranscriptTestRepository {
  final ApiClient _apiClient;

  TranscriptTestRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiError, List<TranscriptTestSet>>> getTranscriptTestSets() async {
    try {
      final response = await _apiClient.getTranscriptTest();
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, List<TranscriptTest>>> getTranscriptTestDetail(String transcriptTestId) async {
    try {
      final response = await _apiClient.getTranscriptTestDetail(transcriptTestId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}

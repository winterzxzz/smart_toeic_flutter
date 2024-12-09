import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class ProfileRepository {
  Future<Either<ApiError, ProfileAnalysis>> getProfileAnalysis();
}

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl(this.apiClient);

  @override
  Future<Either<ApiError, ProfileAnalysis>> getProfileAnalysis() async {
    try {
      final result = await apiClient.getProfileAnalysis();
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}

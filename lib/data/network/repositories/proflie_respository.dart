import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/ui_models/profile_all_analysis.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class ProfileRepository {
  Future<Either<ApiError, ProfileAllAnalysis>> getProfileAllAnalysis();
  Future<Either<ApiError, UserEntity>> updateTargetScore(
      int reading, int listening);
}

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl(this.apiClient);

  @override
  Future<Either<ApiError, ProfileAllAnalysis>> getProfileAllAnalysis() async {
    try {
      final result = await Future.wait([
        apiClient.getProfileAnalysis(),
        apiClient.getSuggestForStudy(),
      ]);

      return Right(ProfileAllAnalysis(
        result[0] as ProfileAnalysis, // Add explicit cast here
        result[1] as String, // Add explicit cast here
      ));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, UserEntity>> updateTargetScore(
      int reading, int listening) async {
    try {
      final result = await apiClient.updateTargetScore({
        'reading': reading,
        'listening': listening,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/data/models/ui_models/profile_all_analysis.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class ProfileRepository {
  Future<Either<ApiError, UserEntity>> getUser();
  Future<Either<ApiError, ProfileAllAnalysis>> getProfileAllAnalysis();
  Future<Either<ApiError, ProfileAnalysis>> getProfileAnalysis();
  Future<Either<ApiError, String>> getSuggestForStudy();
  Future<Either<ApiError, UserEntity>> updateTargetScore(
      int reading, int listening);
  Future<Either<ApiError, String>> updateProfileAvatar(File avatar);
  Future<Either<ApiError, UserEntity>> updateProfile(
      ProfileUpdateRequest request);
}

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl(this.apiClient);

  @override
  Future<Either<ApiError, UserEntity>> getUser() async {
    try {
      final result = await apiClient.getUser();
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

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
  Future<Either<ApiError, ProfileAnalysis>> getProfileAnalysis() async {
    try {
      final result = await apiClient.getProfileAnalysis();
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, String>> getSuggestForStudy() async {
    try {
      final result = await apiClient.getSuggestForStudy();
      return Right(result);
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

  @override
  Future<Either<ApiError, String>> updateProfileAvatar(File avatar) async {
    try {
      final result = await apiClient.updateAvatar(avatar);
      // remove first and last character
      return Right(result.substring(1, result.length - 1));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, UserEntity>> updateProfile(
      ProfileUpdateRequest request) async {
    try {
      final result = await apiClient.updateProfile(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}



import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class BlogRepository {
  Future<Either<ApiError, List<Blog>>> getBlog();
  Future<Either<ApiError, List<Blog>>> searchBlog(String keyword);
}

class BlogRepositoryImpl extends BlogRepository {
  ApiClient apiClient;

  BlogRepositoryImpl(this.apiClient);

  @override
  Future<Either<ApiError, List<Blog>>> getBlog() async {
    try {
      final result = await apiClient.getBlog();
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(e.response?.data));
    }
  }

  @override
  Future<Either<ApiError, List<Blog>>> searchBlog(String keyword) async {
    try {
      final result = await apiClient.searchBlog(keyword);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(e.response?.data));
    }
  }
}

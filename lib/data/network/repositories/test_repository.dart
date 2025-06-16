import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/entities/test/question_explain.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test_submit.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/request/question_explain_request.dart';
import 'package:toeic_desktop/data/models/request/result_item_request.dart';
import 'package:toeic_desktop/data/models/ui_models/home_data_by_user.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class TestRepository {
  Future<Either<ApiError, HomeDataByUser>> getHomeDataByUser();
  Future<Either<ApiError, List<Test>>> getTests({int limit = 3});
  Future<Either<ApiError, HomeDataPublic>> getHomeDataPublic();
  Future<Either<ApiError, List<QuestionModel>>> getDetailTest(String testId);
  Future<Either<ApiError, ResultTestSubmit>> submitTest(
      ResultTestRequest request);
  Future<Either<ApiError, ResultTest>> getAnswerTest(String resultId);
  Future<Either<ApiError, List<ResultTest>>> getResultTests({int limit = 3});
  Future<Either<ApiError, List<QuestionResult>>> getResultTestByResultId(
      String resultId);
  Future<Either<ApiError, QuestionExplain>> getExplainQuestion(
      QuestionExplainRequest request);
}

class TestRepositoryImpl extends TestRepository {
  final ApiClient _apiClient;

  TestRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiError, HomeDataByUser>> getHomeDataByUser() async {
    try {
      final response = await Future.wait([
        _apiClient.getTest(3),
        _apiClient.getResultTestUser(3),
        _apiClient.getBlog(),
      ]);
      return Right(HomeDataByUser(
        tests: response[0] as List<Test>,
        results: response[1] as List<ResultTest>,
        blogs: response[2] as List<Blog>,
      ));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, List<Test>>> getTests({int limit = 3}) async {
    try {
      final response = await _apiClient.getTest(limit);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, HomeDataPublic>> getHomeDataPublic() async {
    try {
      final response = await Future.wait([
        _apiClient.getTestPublic(),
        _apiClient.getBlog(),
      ]);
      return Right(HomeDataPublic(
        tests: response[0] as List<Test>,
        blogs: response[1] as List<Blog>,
      ));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, List<QuestionModel>>> getDetailTest(
      String testId) async {
    try {
      final response = await _apiClient.getDetailTest(testId);
      final validQuestions = response
          .where((q) {
            final idStr = q.id?.toString().trim() ?? '';
            final hasValidId = idStr.isNotEmpty;
            final hasOptions = q.options.isNotEmpty;
            return hasValidId || hasOptions;
          })
          .map((e) => e.toQuestionModel())
          .toList();
      return Right(validQuestions);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, ResultTestSubmit>> submitTest(
      ResultTestRequest request) async {
    try {
      final response = await _apiClient.createResultItem(request);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, ResultTest>> getAnswerTest(String resultId) async {
    try {
      final response = await _apiClient.getResultTest(resultId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, List<ResultTest>>> getResultTests(
      {int limit = 3}) async {
    try {
      final response = await _apiClient.getResultTestUser(limit);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, List<QuestionResult>>> getResultTestByResultId(
      String resultId) async {
    try {
      final response = await _apiClient.getResultTestByResultId(resultId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, QuestionExplain>> getExplainQuestion(
      QuestionExplainRequest request) async {
    try {
      final response = await _apiClient.getExplanation(request);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}

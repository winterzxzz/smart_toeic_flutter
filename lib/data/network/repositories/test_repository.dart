import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test_submit.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/request/result_item_request.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';

abstract class TestRepository {
  Future<Either<Exception, List<Test>>> getTests();
  Future<Either<Exception, List<QuestionModel>>> getDetailTest(String testId);
  Future<Either<Exception, ResultTestSubmit>> submitTest(
      ResultTestRequest request);
  Future<Either<Exception, ResultTest>> getAnswerTest(String resultId);
  Future<Either<Exception, List<ResultTest>>> getResultTests();
  Future<Either<Exception, List<QuestionResult>>> getResultTestByResultId(
      String resultId);
}

class TestRepositoryImpl extends TestRepository {
  final ApiClient _apiClient;

  TestRepositoryImpl(this._apiClient);

  @override
  Future<Either<Exception, List<Test>>> getTests({int limit = 3}) async {
    try {
      final response = await _apiClient.getTest(limit);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<QuestionModel>>> getDetailTest(
      String testId) async {
    try {
      final response = await _apiClient.getDetailTest(testId);
      return Right(response.map((e) => e.toQuestionModel()).toList());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, ResultTestSubmit>> submitTest(
      ResultTestRequest request) async {
    try {
      final response = await _apiClient.createResultItem(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, ResultTest>> getAnswerTest(String resultId) async {
    try {
      final response = await _apiClient.getResultTest(resultId);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<ResultTest>>> getResultTests(
      {int limit = 3}) async {
    try {
      final response = await _apiClient.getResultTestUser(limit);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<QuestionResult>>> getResultTestByResultId(
      String resultId) async {
    try {
      final response = await _apiClient.getResultTestByResultId(resultId);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

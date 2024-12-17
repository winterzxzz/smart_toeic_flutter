import 'package:either_dart/either.dart';
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

abstract class TestRepository {
  Future<Either<Exception, HomeDataByUser>> getTestByUser();
  Future<Either<Exception, List<Test>>> getTests();
  Future<Either<Exception, List<Test>>> getPublicTests();
  Future<Either<Exception, List<QuestionModel>>> getDetailTest(String testId);
  Future<Either<Exception, ResultTestSubmit>> submitTest(
      ResultTestRequest request);
  Future<Either<Exception, ResultTest>> getAnswerTest(String resultId);
  Future<Either<Exception, List<ResultTest>>> getResultTests();
  Future<Either<Exception, List<QuestionResult>>> getResultTestByResultId(
      String resultId);
  Future<Either<Exception, QuestionExplain>> getExplainQuestion(
      QuestionExplainRequest request);
}

class TestRepositoryImpl extends TestRepository {
  final ApiClient _apiClient;

  TestRepositoryImpl(this._apiClient);

  @override
  Future<Either<Exception, HomeDataByUser>> getTestByUser(
      {int limit = 3}) async {
    try {
      final response = await Future.wait([
        _apiClient.getTest(limit),
        _apiClient.getResultTestUser(limit),
      ]);
      return Right(HomeDataByUser(
        tests: response[0] as List<Test>,
        results: response[1] as List<ResultTest>,
      ));
    } on Exception catch (e) {
      return Left(e);
    }
  }

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
  Future<Either<Exception, List<Test>>> getPublicTests() async {
    try {
      final response = await _apiClient.getTestPublic();
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
  
  @override
  Future<Either<Exception, QuestionExplain>> getExplainQuestion(QuestionExplainRequest request)async{
    try {
      final response = await _apiClient.getExplanation(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

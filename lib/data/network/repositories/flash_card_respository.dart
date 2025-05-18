import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_ai_gen.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/new_set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/word/word_random.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class FlashCardRespository {
  Future<Either<ApiError, SetFlashCard>> createFlashCardSet(
      String title, String description);
  Future<Either<ApiError, List<SetFlashCard>>> getSetFlashCards();
  Future<Either<ApiError, void>> deleteFlashCardSet(String id);
  Future<Either<ApiError, SetFlashCard>> updateFlashCardSet(
      String id, String title, String description);

  Future<Either<ApiError, FlashCard>> createFlashCard(
      FlashCardRequest flashCardRequest);
  Future<Either<ApiError, List<FlashCard>>> getFlashCards(String setId);
  Future<Either<ApiError, FlashCard>> updateFlashCard(
      String id, String word, String translation);
  Future<Either<ApiError, void>> deleteFlashCard(String id);

  Future<Either<ApiError, List<SetFlashCardLearning>>>
      getSetFlashCardsLearning();
  Future<Either<ApiError, List<FlashCardLearning>>> getFlashCardsLearning(
      String learningSetId);
  Future<Either<ApiError, void>> deleteFlashCardLearning(String learningSetId);
  Future<Either<ApiError, NewSetFlashCardLearning>> updateFlashCardLearning(
      String learningSetId);
  Future<Either<ApiError, FlashCardAiGen>> getFlashCardInforByAI(String prompt);

  Future<Either<ApiError, void>> updateSessionScore(
      List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequest);

  Future<Either<ApiError, List<WordRandom>>> getRandom4Words();
}

class FlashCardRespositoryImpl extends FlashCardRespository {
  final ApiClient _apiClient;

  FlashCardRespositoryImpl(this._apiClient);

  @override
  Future<Either<ApiError, List<SetFlashCard>>> getSetFlashCards() async {
    try {
      final response = await _apiClient.getFlashCardUser();
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, List<SetFlashCardLearning>>>
      getSetFlashCardsLearning() async {
    try {
      final response = await _apiClient.getFlashCardSetLearning();
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, List<FlashCard>>> getFlashCards(String setId) async {
    try {
      final response = await _apiClient.getFlashCardSet(setId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, SetFlashCard>> createFlashCardSet(
      String title, String description) async {
    try {
      final response = await _apiClient.createFlashCardSet(title, description);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteFlashCardSet(String id) async {
    try {
      await _apiClient.deleteFlashCardSet(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, SetFlashCard>> updateFlashCardSet(
      String id, String title, String description) async {
    try {
      final response =
          await _apiClient.updateFlashCardSet(id, title, description);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, FlashCard>> createFlashCard(
      FlashCardRequest flashCardRequest) async {
    try {
      final response = await _apiClient.createFlashCard(flashCardRequest);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteFlashCard(String id) async {
    try {
      await _apiClient.deleteFlashCard(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, FlashCard>> updateFlashCard(
      String id, String word, String translation) async {
    try {
      final response = await _apiClient.updateFlashCard(id, word, translation);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, FlashCardAiGen>> getFlashCardInforByAI(
      String prompt) async {
    try {
      final response = await _apiClient.getFlashCardInforByAI(prompt);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteFlashCardLearning(
      String learningSetId) async {
    try {
      await _apiClient.deleteFlashCardLearning(learningSetId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, List<FlashCardLearning>>> getFlashCardsLearning(
      String learningSetId) async {
    try {
      final response = await _apiClient.getFlashCardLearning(learningSetId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }

  @override
  Future<Either<ApiError, NewSetFlashCardLearning>> updateFlashCardLearning(
      String learningSetId) async {
    try {
      final response = await _apiClient.updateFlashCardLearning(learningSetId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(e.response?.data));
    }
  }

  @override
  Future<Either<ApiError, void>> updateSessionScore(
      List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequest) async {
    try {
      final response =
          await _apiClient.updateSessionScore(flashCardQuizzScoreRequest);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(e.response?.data));
    }
  }

  @override
  Future<Either<ApiError, List<WordRandom>>> getRandom4Words() async {
    try {
      final response = await _apiClient.getRandom4Words();
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromJson(jsonDecode(e.response?.data)));
    }
  }
}

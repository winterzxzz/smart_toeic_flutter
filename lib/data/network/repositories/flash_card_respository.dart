import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card_ai_gen.dart';
import 'package:toeic_desktop/data/models/entities/flash_card_quizz.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quiz_request.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';

abstract class FlashCardRespository {
  Future<Either<Exception, List<SetFlashCard>>> getSetFlashCards();
  Future<Either<Exception, List<FlashCard>>> getFlashCards(String setId);
  Future<Either<Exception, SetFlashCard>> createFlashCardSet(
      String title, String description);
  Future<Either<Exception, void>> deleteFlashCardSet(String id);
  Future<Either<Exception, SetFlashCard>> updateFlashCardSet(
      String id, String title, String description);
  Future<Either<Exception, FlashCard>> createFlashCard(
      FlashCardRequest flashCardRequest);
  Future<Either<Exception, FlashCard>> updateFlashCard(
      String id, String word, String translation);
  Future<Either<Exception, void>> deleteFlashCard(String id);
  Future<Either<Exception, FlashCardAiGen>> getFlashCardInforByAI(
      String prompt);
  Future<Either<Exception, List<FlashCardQuizz>>> getFlashCardQuizz(
      FlashCardQuizRequest request);
}

class FlashCardRespositoryImpl extends FlashCardRespository {
  final ApiClient _apiClient;

  FlashCardRespositoryImpl(this._apiClient);

  @override
  Future<Either<Exception, List<SetFlashCard>>> getSetFlashCards() async {
    try {
      final response = await _apiClient.getFlashCardUser();
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<FlashCard>>> getFlashCards(String setId) async {
    try {
      final response = await _apiClient.getFlashCardSet(setId);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, SetFlashCard>> createFlashCardSet(
      String title, String description) async {
    try {
      final response = await _apiClient.createFlashCardSet(title, description);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> deleteFlashCardSet(String id) async {
    try {
      await _apiClient.deleteFlashCardSet(id);
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, SetFlashCard>> updateFlashCardSet(
      String id, String title, String description) async {
    try {
      final response =
          await _apiClient.updateFlashCardSet(id, title, description);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, FlashCard>> createFlashCard(
      FlashCardRequest flashCardRequest) async {
    try {
      final response = await _apiClient.createFlashCard(flashCardRequest);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> deleteFlashCard(String id) async {
    try {
      await _apiClient.deleteFlashCard(id);
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, FlashCard>> updateFlashCard(
      String id, String word, String translation) async {
    try {
      final response = await _apiClient.updateFlashCard(id, word, translation);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, FlashCardAiGen>> getFlashCardInforByAI(
      String prompt) async {
    try {
      final response = await _apiClient.getFlashCardInforByAI(prompt);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<FlashCardQuizz>>> getFlashCardQuizz(
      FlashCardQuizRequest request) async {
    try {
      final response = await _apiClient.getFlashCardQuizz(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

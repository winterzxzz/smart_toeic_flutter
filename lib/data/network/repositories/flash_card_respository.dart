import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';

abstract class FlashCardRespository {
  Future<Either<Exception, List<SetFlashCard>>> getSetFlashCards();
  Future<Either<Exception, List<FlashCard>>> getFlashCards(String setId);
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
}

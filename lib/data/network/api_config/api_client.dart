import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card_ai_gen.dart';
import 'package:toeic_desktop/data/models/entities/flash_card_quizz.dart';
import 'package:toeic_desktop/data/models/entities/question.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/data/models/entities/test.dart';
import 'package:toeic_desktop/data/models/entities/user_entity.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quiz_request.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // AUTH USER
  @POST('/user/auth/signup')
  Future<UserEntity> signUp(
    @Field("email") String email,
    @Field("name") String name,
    @Field("password") String password,
  );

  @POST('/user/auth/login')
  Future<UserEntity> login(
    @Field("email") String email,
    @Field("password") String password,
  );

  @GET('user/auth/getinfor')
  Future<UserEntity> getUser();

  @GET('/user/flashcard/set?setFlashcardId={setFlashcardId}')
  Future<List<FlashCard>> getFlashCardSet(
    @Path("setFlashcardId") String setFlashcardId,
  );

  @POST('/user/flashcard')
  Future<FlashCard> createFlashCard(
    @Body() FlashCardRequest flashCard,
  );

  @PATCH('/user/flashcard')
  Future<FlashCard> updateFlashCard(
    @Field("id") String id,
    @Field("word") String word,
    @Field("translation") String translation,
  );

  @DELETE('/user/flashcard')
  Future<void> deleteFlashCard(
    @Field("id") String id,
  );

  @GET('/user/set-flashcard/user')
  Future<List<SetFlashCard>> getFlashCardUser();

  @GET('/user/set-flashcard/public')
  Future<List<SetFlashCard>> getFlashCardPublic();

  @POST('/user/set-flashcard')
  Future<SetFlashCard> createFlashCardSet(
    @Field("title") String title,
    @Field("description") String description,
  );

  @PATCH('/user/set-flashcard')
  Future<SetFlashCard> updateFlashCardSet(
    @Field("id") String id,
    @Field("title") String title,
    @Field("description") String description,
  );

  @DELETE('/user/set-flashcard')
  Future<void> deleteFlashCardSet(
    @Field("id") String id,
  );

  @GET('/user/test?limit={limit}')
  Future<List<Test>> getTest(
    @Query("limit") int limit,
  );

  @GET('/pub/test')
  Future<List<Test>> getTestPublic();

  @GET('/pub/test/handle-excel?id={testId}')
  Future<List<Question>> getDetailTest(
    @Path("testId") String testId,
  );

  @POST('/user/ai-chat/get-fc-infor')
  Future<FlashCardAiGen> getFlashCardInforByAI(
    @Field("prompt") String prompt,
  );

  @POST('/user/ai-chat/get-quizz')
  Future<List<FlashCardQuizz>> getFlashCardQuizz(
    @Body() FlashCardQuizRequest request,
  );
}

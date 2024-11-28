import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/question.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/data/models/entities/test.dart';
import 'package:toeic_desktop/data/models/entities/user_entity.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';

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

  @GET('/user/flashcard/set?setFlashcardId={setFlashcardId}')
  Future<List<FlashCard>> getFlashCardSet(
    @Path("setFlashcardId") String setFlashcardId,
  );

  @GET('/user/set-flashcard/user')
  Future<List<SetFlashCard>> getFlashCardUser();

  @GET('/user/set-flashcard/public')
  Future<List<SetFlashCard>> getFlashCardPublic();

  @GET('/user/test?limit={limit}')
  Future<List<Test>> getTest(
    @Query("limit") int limit,
  );

  @GET('/pub/test/handle-excel?id={testId}')
  Future<List<Question>> getDetailTest(
    @Path("testId") String testId,
  );
}

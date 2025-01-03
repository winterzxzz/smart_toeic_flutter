import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_ai_gen.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/new_set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/word/word_random.dart';
import 'package:toeic_desktop/data/models/entities/payment/payment.dart';
import 'package:toeic_desktop/data/models/entities/payment/payment_status.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/data/models/entities/test/question.dart';
import 'package:toeic_desktop/data/models/entities/test/question_explain.dart';
import 'package:toeic_desktop/data/models/entities/test/question_result.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test_submit.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test.dart';
import 'package:toeic_desktop/data/models/entities/transcript/transcript_test_set.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/data/models/request/question_explain_request.dart';
import 'package:toeic_desktop/data/models/request/result_item_request.dart';

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

  @GET('/user/auth/getinfor')
  Future<UserEntity> getUser();

  // PROFILE
  @GET('/user/profile/analysis')
  Future<ProfileAnalysis> getProfileAnalysis();

  // FLASH CARD
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

  @GET('/user/learning-set/user')
  Future<List<SetFlashCardLearning>> getFlashCardSetLearning();

  @GET('/user/learning-flashcard/set?learningSetId={learningSetId}')
  Future<List<FlashCardLearning>> getFlashCardLearning(
    @Path("learningSetId") String learningSetId,
  );

  @DELETE('/user/learning-set')
  Future<void> deleteFlashCardLearning(
    @Field("learningSetId") String learningSetId,
  );

  @POST('/user/learning-set')
  Future<NewSetFlashCardLearning> updateFlashCardLearning(
    @Field("setFlashcardId") String learningSetId,
  );

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

  // TEST
  @GET('/user/test')
  Future<List<Test>> getTest(
    @Query("limit") int limit,
  );

  @GET('/pub/test')
  Future<List<Test>> getTestPublic();

  @GET('/pub/test/handle-excel?id={testId}')
  Future<List<Question>> getDetailTest(
    @Path("testId") String testId,
  );

  @POST('/user/result/items')
  Future<ResultTestSubmit> createResultItem(
    @Body() ResultTestRequest request,
  );

  @GET('/user/result-item/result?resultId={resultId}')
  Future<ResultTest> getResultTest(
    @Path("resultId") String resultId,
  );

  @GET('/user/result-item/result?resultId={resultId}')
  Future<List<QuestionResult>> getResultTestByResultId(
    @Path("resultId") String resultId,
  );

  @POST('/user/ai-chat/get-fc-infor/json')
  Future<FlashCardAiGen> getFlashCardInforByAI(
    @Field("prompt") String prompt,
  );

  // @POST('/user/ai-chat/get-quizz/json')
  // Future<List<FlashCardQuizz>> getFlashCardQuizz(
  //   @Body() FlashCardQuizRequest request,
  // );

  @POST('/user/ai-chat/suggest-for-study')
  Future<String> getSuggestForStudy();

  @GET('/user/result/user?limit={limit}')
  Future<List<ResultTest>> getResultTestUser(
    @Query("limit") int limit,
  );

  // Premium
  @POST('/user/payment')
  Future<Payment> getPayment();

  @GET('/user/payment/status?transId={transId}')
  Future<PaymentStatus> checkPaymentStatus(
    @Path("transId") String transId,
  );

  @POST('/user/profile/update-target-score')
  Future<UserEntity> updateTargetScore(
    @Body() Map<String, dynamic> body,
  );

  @POST('/user/ai-chat/get-explanation/json')
  Future<QuestionExplain> getExplanation(
    @Body() QuestionExplainRequest request,
  );

  @POST('/user/profile/update-avatar')
  Future<String> updateAvatar(
    @Part(
      name: "avatar",
    )
    File avatar,
  );

  @POST('/user/profile/update-profile')
  Future<UserEntity> updateProfile(
    @Body() ProfileUpdateRequest request,
  );

  @POST('/user/auth/otp/reset-password')
  Future<void> resetPassword(
    @Field("email") String email,
  );

  // @POST('/user/auth/request/reset-password')
  // Future<void> requestResetPassword(
  //   @Field("email") String email,
  // );

  @POST('/user/learning-flashcard/update-session-score')
  Future<void> updateSessionScore(
    @Body() List<FlashCardQuizzScoreRequest> body,
  );

  @GET('/pub/transcript-test')
  Future<List<TranscriptTestSet>> getTranscriptTest();

  @GET('/pub/word/4-random')
  Future<List<WordRandom>> getRandom4Words();

  @GET('/pub/transcript-test-item/transcript-test-id?transcriptTestId={transcriptTestId}')
  Future<List<TranscriptTest>> getTranscriptTestDetail(
    @Path("transcriptTestId") String transcriptTestId,
  );
  
  @GET('/pub/blog')
  Future<List<Blog>> getBlog();

  @GET('/pub/blog/search?search={search}')
  Future<List<Blog>> searchBlog(
    @Path("search") String search,
  );
}

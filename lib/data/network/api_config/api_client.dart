import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:toeic_desktop/data/models/entities/user_entity.dart';

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
}

part of 'app.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector
    ..registerLazySingleton<Dio>(() => DioClient.createNewDio())
    ..registerLazySingleton<ApiClient>(
        () => ApiClient(injector(), baseUrl: AppConfigs.baseUrl))
    ..registerLazySingleton<AppSettingCubit>(() => AppSettingCubit())
    ..registerFactory<LoginCubit>(() => LoginCubit(injector()))
    ..registerLazySingleton<TestRepository>(
        () => TestRepositoryImpl(injector()))
    ..registerFactory<PracticeTestCubit>(() => PracticeTestCubit(injector()))
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(injector()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(injector()))
    ..registerLazySingleton<UserCubit>(() => UserCubit())
    ..registerLazySingleton<FlashCardRespository>(
        () => FlashCardRespositoryImpl(injector()))
    ..registerFactory<FlashCardCubit>(() => FlashCardCubit(injector()))
    ..registerFactory<FlashCardDetailCubit>(
        () => FlashCardDetailCubit(injector()))
    ..registerFactory<DeThiOnlineCubit>(() => DeThiOnlineCubit(injector()))
    ..registerFactory<SplashCubit>(() => SplashCubit(injector()));
}

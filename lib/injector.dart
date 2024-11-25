part of 'app.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector
    ..registerLazySingleton<Dio>(() => DioClient.createNewDio())
    ..registerLazySingleton<ApiClient>(
        () => ApiClient(injector(), baseUrl: AppConfigs.baseUrl))
    ..registerLazySingleton<AppSettingCubit>(() => AppSettingCubit())
    ..registerLazySingleton<BottomTabCubit>(() => BottomTabCubit())
    ..registerFactory<LoginCubit>(() => LoginCubit(injector()))
    ..registerLazySingleton<PracticeTestRepository>(
        () => PracticeTestRepositoryImpl(injector()))
    ..registerFactory<PracticeTestCubit>(() => PracticeTestCubit(injector()))
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(injector()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(injector()))
    ..registerLazySingleton<UserCubit>(() => UserCubit());
}

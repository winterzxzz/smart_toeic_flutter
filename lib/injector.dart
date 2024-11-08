part of 'app.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector
    ..registerLazySingleton<Dio>(() => DioClient.createNewDio())
    ..registerLazySingleton<ApiClient>(
        () => ApiClient(injector(), baseUrl: AppConfigs.baseUrl))
    ..registerLazySingleton<AppSettingCubit>(() => AppSettingCubit())
    ..registerLazySingleton<BottomTabCubit>(() => BottomTabCubit());
}

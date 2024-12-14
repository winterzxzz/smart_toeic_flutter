part of 'app.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector
    ..registerLazySingleton<Dio>(() => DioClient.createNewDio())
    ..registerLazySingleton<ApiClient>(
        () => ApiClient(injector(), baseUrl: AppConfigs.baseUrl))
    ..registerLazySingleton<TestRepository>(
        () => TestRepositoryImpl(injector()))
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(injector()))
    ..registerLazySingleton<FlashCardRespository>(
        () => FlashCardRespositoryImpl(injector()))
    ..registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(injector()))
    ..registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(injector()))

    ..registerLazySingleton<AppSettingCubit>(() => AppSettingCubit())
    ..registerFactory<LoginCubit>(() => LoginCubit(injector()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(injector()))
    ..registerLazySingleton<UserCubit>(() => UserCubit(injector()))

    ..registerFactory<HomeCubit>(() => HomeCubit(injector()))

    ..registerFactory<SplashCubit>(() => SplashCubit(injector()))

    ..registerFactory<DeThiOnlineCubit>(() => DeThiOnlineCubit(injector()))
    ..registerFactory<PracticeTestCubit>(() => PracticeTestCubit(injector()))

    ..registerFactory<FlashCardCubit>(() => FlashCardCubit(injector()))
    ..registerFactory<FlashCardDetailCubit>(
        () => FlashCardDetailCubit(injector()))
    ..registerFactory<FlashCardLearnFlipCubit>(() => FlashCardLearnFlipCubit())
    ..registerFactory<FlashCardQuizzCubit>(
        () => FlashCardQuizzCubit(injector()))
    ..registerFactory<FlashCardDetailLearningCubit>(
        () => FlashCardDetailLearningCubit(injector()))

    ..registerFactory<AnalysisCubit>(() => AnalysisCubit(injector()))
    ..registerFactory<UpgradeAccountCubit>(
        () => UpgradeAccountCubit(injector()))
    ..registerFactory<CheckPaymentStatusCubit>(
        () => CheckPaymentStatusCubit(injector()));
}

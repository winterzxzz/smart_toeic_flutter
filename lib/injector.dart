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
    ..registerFactory<LoginCubit>(() => LoginCubit(injector()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(injector()))
    ..registerLazySingleton<UserCubit>(() => UserCubit(injector()))
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
        () => CheckPaymentStatusCubit(injector()))
    ..registerFactory<ProfileCubit>(() => ProfileCubit(injector()))
    ..registerFactory<GetRandomWordCubit>(() => GetRandomWordCubit(injector()))
    ..registerLazySingleton<TranscriptTestRepository>(
        () => TranscriptTestRepositoryImpl(injector()))
    ..registerFactory<ListenCopyCubit>(() => ListenCopyCubit(injector()))
    ..registerFactory<TranscriptTestDetailCubit>(
        () => TranscriptTestDetailCubit(injector()))
    ..registerLazySingleton<BlogRepository>(
        () => BlogRepositoryImpl(injector()))
    ..registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(injector()))
    ..registerFactory<BlogCubit>(() => BlogCubit(injector()))
    ..registerFactory<HistoryTestCubit>(() => HistoryTestCubit(injector()));

  if (!injector.isRegistered<HomeCubit>()) {
    injector.registerLazySingleton<HomeCubit>(() => HomeCubit(injector()));
  }

  if (!injector.isRegistered<DeThiOnlineCubit>()) {
    injector.registerLazySingleton<DeThiOnlineCubit>(
        () => DeThiOnlineCubit(injector()));
  }

  if (!injector.isRegistered<SplashCubit>()) {
    injector.registerFactory<SplashCubit>(() => SplashCubit(injector()));
  }

  if (!injector.isRegistered<AppSettingCubit>()) {
    injector.registerLazySingleton<AppSettingCubit>(() => AppSettingCubit());
  }
}

part of 'app.dart';

final injector = GetIt.instance;

Future<void> init() async {
  // Core dependencies
  injector
    ..registerLazySingleton<Dio>(() => DioClient.createNewDio())
    ..registerLazySingleton<SharedPreferencesHelper>(
        () => SharedPreferencesHelper())
    ..registerLazySingleton<ApiClient>(
        () => ApiClient(injector(), baseUrl: AppConfigs.baseUrl));

  // Repository dependencies
  injector
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
    ..registerLazySingleton<TranscriptTestRepository>(
        () => TranscriptTestRepositoryImpl(injector()))
    ..registerLazySingleton<BlogRepository>(
        () => BlogRepositoryImpl(injector()));

  // Cubit dependencies (short-lived objects)
  injector
    ..registerFactory<LoginCubit>(() => LoginCubit(injector()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(injector()))
    ..registerFactory<PracticeTestCubit>(() => PracticeTestCubit(injector()))
    ..registerLazySingleton<FlashCardCubit>(() => FlashCardCubit(injector()))
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
    ..registerFactory<GetRandomWordCubit>(() => GetRandomWordCubit(injector()))
    ..registerFactory<ListenCopyCubit>(() => ListenCopyCubit(injector()))
    ..registerFactory<TranscriptCheckerService>(
        () => TranscriptCheckerService())
    ..registerFactory<TranscriptTestDetailCubit>(
        () => TranscriptTestDetailCubit(
              transcriptTestRepository: injector(),
              transcriptCheckerService: injector(),
            ))
    ..registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(injector()))
    ..registerFactory<BlogCubit>(() => BlogCubit(injector()))
    ..registerFactory<HistoryTestCubit>(() => HistoryTestCubit(injector()));

  // Singleton Cubits (long-lived objects)
  injector
    ..registerLazySingleton<EntrypointCubit>(() => EntrypointCubit())
    ..registerLazySingleton<UserCubit>(() => UserCubit(injector()));

  // Conditional registrations
  if (!injector.isRegistered<TestsCubit>()) {
    injector.registerLazySingleton<TestsCubit>(() => TestsCubit(injector()));
  }

  if (!injector.isRegistered<SplashCubit>()) {
    injector.registerFactory<SplashCubit>(() => SplashCubit(injector()));
  }

  if (!injector.isRegistered<AppSettingCubit>()) {
    injector.registerLazySingleton<AppSettingCubit>(() => AppSettingCubit());
  }
}

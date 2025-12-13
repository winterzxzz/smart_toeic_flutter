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
        () => BlogRepositoryImpl(injector()))
    ..registerLazySingleton<ChatAiRepository>(
        () => ChatAiRepositoryImpl(injector()))

    // Services
    ..registerLazySingleton<SpeechService>(() => SpeechService())
    ..registerLazySingleton<NotiService>(() => NotiService())
    ..registerLazySingleton<WidgetService>(() => WidgetService())
    ..registerLazySingleton<Web3Service>(() => Web3Service());
  // Cubit dependencies (short-lived objects)
  injector
    ..registerFactory<SplashCubit>(() => SplashCubit(injector()))
    ..registerFactory<LoginCubit>(() => LoginCubit(injector()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(injector()))
    ..registerFactory<PracticeTestCubit>(() => PracticeTestCubit(injector()))
    ..registerFactory<FlashCardDetailCubit>(() => FlashCardDetailCubit(
          flashCardRespository: injector(),
          widgetService: injector(),
        ))
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
              speechService: injector(),
            ))
    ..registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(injector()))
    ..registerFactory<BlogCubit>(() => BlogCubit(injector()))
    ..registerFactory<HistoryTestCubit>(() => HistoryTestCubit(injector()))
    ..registerFactory<CertificatesCubit>(() => CertificatesCubit(
          web3Service: injector(),
        ))
    ..registerFactory<ChatAiCubit>(() => ChatAiCubit(injector()));

  // Singleton Cubits (long-lived objects)
  injector
    ..registerLazySingleton<EntrypointCubit>(() => EntrypointCubit())
    ..registerLazySingleton<UserCubit>(() => UserCubit(injector()))
    ..registerLazySingleton<FlashCardCubit>(() => FlashCardCubit(injector()))
    ..registerLazySingleton<TestsCubit>(() => TestsCubit(injector()))
    ..registerLazySingleton<AppSettingCubit>(() => AppSettingCubit(
          widgetService: injector(),
        ));
}

/// Not need to reset app setting cubit and user cubit
Future<void> resetSingletonCubitsAndInitAgain() async {
  if (injector.isRegistered<EntrypointCubit>()) {
    await injector.resetLazySingleton<EntrypointCubit>();
  }
  if (injector.isRegistered<FlashCardCubit>()) {
    await injector.resetLazySingleton<FlashCardCubit>();
  }
  if (injector.isRegistered<TestsCubit>()) {
    await injector.resetLazySingleton<TestsCubit>();
  }
}

import 'package:dio/dio.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';
import 'package:toeic_desktop/data/network/repositories/blog_repository.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toeic_desktop/data/network/repositories/payment_repository.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/data/network/repositories/transcript_test.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/analysis_cubit.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_cubit.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_learning_detail/flash_card_detail_learning_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/cubit/get_random_word_cubit.dart';
import 'package:toeic_desktop/ui/page/history_test/history_test_cubit.dart';
import 'package:toeic_desktop/ui/page/home/home_cubit.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_cubit.dart';
import 'package:toeic_desktop/ui/page/profile/profile_cubit.dart';
import 'package:toeic_desktop/ui/page/tests/test_online_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_learn_flip/flash_card_learn_flip_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/login/login_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/reigster/register_cubit.dart';
import 'package:toeic_desktop/ui/page/splash/splash_cubit.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_cubit.dart';
import 'common/configs/app_configs.dart';
import 'common/global_blocs/setting/app_setting_cubit.dart';
import 'common/router/route_config.dart';
import 'data/network/api_config/api_client.dart';
import 'data/network/dio_client.dart';
import 'data/models/enums/language.dart';
import 'language/generated/l10n.dart';
import 'ui/common/app_colors.dart';
import 'ui/common/app_themes.dart';

part 'injector.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => injector<AuthRepository>(),
        ),
        RepositoryProvider<FlashCardRespository>(
          create: (context) => injector<FlashCardRespository>(),
        ),
        RepositoryProvider<TestRepository>(
          create: (context) => injector<TestRepository>(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => injector<ProfileRepository>(),
        ),
        RepositoryProvider<PaymentRepository>(
          create: (context) => injector<PaymentRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingCubit>(
              create: (context) => injector<AppSettingCubit>()),
          BlocProvider<UserCubit>(
            create: (context) => injector<UserCubit>(),
          ),
        ],
        child: BlocBuilder<AppSettingCubit, AppSettingState>(
          buildWhen: (previous, current) {
            return previous.themeMode != current.themeMode ||
                previous.primaryColor != current.primaryColor ||
                previous.isDynamicColor != current.isDynamicColor ||
                previous.language != current.language;
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                _hideKeyboard(context);
              },
              child: GlobalLoaderOverlay(
                overlayWidgetBuilder: (_) {
                  return Center(
                    child: Container(
                      color: AppColors.gray1,
                      width: 40,
                      height: 40,
                      child: Center(
                          child: Container(
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                      )),
                    ),
                  );
                },
                child: _buildMaterialApp(
                  locale: state.language.local,
                  theme: state.themeMode,
                  primaryColor: state.primaryColor,
                  isDynamicColor: state.isDynamicColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialApp({
    required Locale locale,
    required ThemeMode theme,
    required Color primaryColor,
    required bool isDynamicColor,
  }) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme? lightColorScheme;
      ColorScheme? darkColorScheme;
      if (lightDynamic != null && darkDynamic != null && isDynamicColor) {
        lightColorScheme = lightDynamic;
        darkColorScheme = darkDynamic;
      } else {
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        );
        darkColorScheme = ColorScheme.fromSeed(
            seedColor: primaryColor, brightness: Brightness.dark);
      }
      return ToastificationWrapper(
        child: MaterialApp.router(
          title: AppConfigs.appName,
          debugShowCheckedModeBanner: false,
          theme: AppThemes(
            brightness:
                theme == ThemeMode.dark ? Brightness.dark : Brightness.light,
          ).theme.copyWith(
                colorScheme: theme == ThemeMode.dark
                    ? darkColorScheme
                    : lightColorScheme,
              ),
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
          ],
          locale: locale,
          supportedLocales: S.delegate.supportedLocales,
        ),
      );
    });
  }

  void _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

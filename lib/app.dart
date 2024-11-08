import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
    //Setup PortraitUp only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingCubit>(
            create: (context) => injector<AppSettingCubit>()),
        BlocProvider<BottomTabCubit>(
            create: (context) => injector<BottomTabCubit>()),
      ],
      child: BlocBuilder<AppSettingCubit, AppSettingState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              _hideKeyboard(context);
            },
            child: GlobalLoaderOverlay(
              useDefaultLoading: false,
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    )),
                  ),
                );
              },
              child: _buildMaterialApp(
                locale: state.language.local,
                theme: state.themeMode,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMaterialApp({
    required Locale locale,
    required ThemeMode theme,
  }) {
    return MaterialApp.router(
      title: AppConfigs.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes(
        brightness:
            theme == ThemeMode.dark ? Brightness.dark : Brightness.light,
      ).theme,
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  void _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

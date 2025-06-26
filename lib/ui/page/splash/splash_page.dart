import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/splash/splash_cubit.dart';
import 'package:toeic_desktop/ui/page/splash/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<SplashCubit>()..getUser(),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          GoRouter.of(context).goNamed(AppRouter.bottomTab);
        } else if (state.loadStatus == LoadStatus.failure) {
          final isFirstTime = injector<SharedPreferencesHelper>().isFirstRun();
          if (isFirstTime) {
            GoRouter.of(context).goNamed(AppRouter.onboarding);
          } else {
            GoRouter.of(context).goNamed(AppRouter.login);
          }
        }
      },
      child: Scaffold(
          body: Center(
        child: Hero(
          tag: 'app_logo',
          child: Image.asset(
            AppImages.appLogo,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}

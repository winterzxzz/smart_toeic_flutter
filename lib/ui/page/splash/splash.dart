import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:lottie/lottie.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
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
          GoRouter.of(context).goNamed(AppRouter.home);
        } else if (state.loadStatus == LoadStatus.failure) {
          GoRouter.of(context).goNamed(AppRouter.login);
          if (state.message.isNotEmpty) {
            showToast(title: state.message, type: ToastificationType.error);
          }
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Lottie.asset(AppImages.splashAnimation,
              width: double.infinity,
              height: double
                  .infinity) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}

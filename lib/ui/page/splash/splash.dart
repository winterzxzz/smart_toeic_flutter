import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iscanner_app/common/router/route_config.dart';
import 'package:iscanner_app/ui/common/app_images.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Lottie.asset(AppImages.splashAnimation,
            width: double.infinity,
            height: double
                .infinity) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void redirect() async {
    await Future.delayed(const Duration(seconds: 2), () {
      GoRouter.of(context).goNamed(AppRouter.bottomTab);
    });
  }
}

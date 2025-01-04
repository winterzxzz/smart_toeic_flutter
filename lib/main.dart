import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/global_blocs/app_bloc_observer.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'common/configs/app_configs.dart';
import 'common/configs/app_env_config.dart';
import 'data/database/share_preferences_helper.dart';

void main() async {
  AppConfigs.env = Environment.dev;
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    maximumSize: Size(1920, 1080),
    center: true,
    title: 'Toeic Desktop',
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await SharedPreferencesHelper().initialize();
  await init();
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

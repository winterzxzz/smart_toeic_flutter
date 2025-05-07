import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/global_blocs/app_bloc_observer.dart';

import 'app.dart';
import 'common/configs/app_configs.dart';
import 'common/configs/app_env_config.dart';
import 'data/database/share_preferences_helper.dart';

void main() async {
  AppConfigs.env = Environment.dev;
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().initialize();
  await init();
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

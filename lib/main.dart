import 'package:flutter/material.dart';

import 'app.dart';
import 'common/configs/app_configs.dart';
import 'common/configs/app_env_config.dart';
import 'data/database/share_preferences_helper.dart';

void main() async {
  AppConfigs.env = Environment.dev;
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().initialize();
  await init();

  runApp(const MyApp());
}

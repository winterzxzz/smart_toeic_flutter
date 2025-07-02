import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/data/services/noti_service.dart';

import 'app.dart';
import 'common/configs/app_configs.dart';
import 'common/configs/app_env_config.dart';
import 'data/database/share_preferences_helper.dart';

void main() async {
  AppConfigs.env = Environment.dev;
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ['105B2DCAFB40A94A3CE6C7EE0A4F4B72']),
  );
  await MobileAds.instance.initialize();
  await init();
  await injector<SharedPreferencesHelper>().initialize();
  await injector<NotiService>().initialize();
  runApp(const MyApp());
}

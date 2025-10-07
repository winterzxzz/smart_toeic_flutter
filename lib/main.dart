import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/data/services/noti_service.dart';
import 'package:toeic_desktop/data/services/ad_service.dart';

import 'app.dart';
import 'common/configs/app_configs.dart';
import 'common/configs/app_env_config.dart';
import 'data/database/share_preferences_helper.dart';

late List<CameraDescription> cameras;

void main() async {
  AppConfigs.env = Environment.dev;
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure for test ads only - no device ID needed for test ad units
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: <String>[], // Empty list works with test ad unit IDs
    ),
  );
  
  await MobileAds.instance.initialize();
  await init();
  await injector<SharedPreferencesHelper>().initialize();
  await injector<NotiService>().initialize();
  await injector<AdService>().initialize();
  cameras = await availableCameras();
  runApp(const MyApp());
}

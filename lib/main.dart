import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:toeic_desktop/data/services/noti_service.dart';
import 'package:toeic_desktop/data/services/widget_navigation_service.dart';

import 'app.dart';
import 'common/configs/app_configs.dart';
import 'common/configs/app_env_config.dart';
import 'data/database/share_preferences_helper.dart';

void main() async {
  AppConfigs.env = Environment.dev;
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().initialize();
  HomeWidget.registerInteractivityCallback(backgroundCallback);
  await init();
  await NotiService().initialize();

  // Initialize widget navigation service after Flutter is ready
  WidgetsBinding.instance.addPostFrameCallback((_) {
    WidgetNavigationService.initialize();
  });

  runApp(const MyApp());
}

// Background callback for widget updates when launching from widget tap
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'update') {
    final now = DateTime.now().toLocal().toString();
    await HomeWidget.saveWidgetData('widgetText', 'Updated at $now');
    await HomeWidget.updateWidget(name: 'HomeWidgetProvider');
  }
}

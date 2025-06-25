import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/services/noti_service.dart';
import 'package:toeic_desktop/data/services/widget_service.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';

import '../../configs/app_configs.dart';
import '../../../data/database/share_preferences_helper.dart';
import '../../../data/models/enums/language.dart';

part 'app_setting_state.dart';

class AppSettingCubit extends Cubit<AppSettingState> {
  final WidgetService widgetService;
  AppSettingCubit({
    required this.widgetService,
  }) : super(const AppSettingState());

  Future<void> getInitialSetting() async {
    final currentLanguage = await SharedPreferencesHelper.getCurrentLanguage();
    final themeMode = await SharedPreferencesHelper.getTheme();
    final primaryColor = await SharedPreferencesHelper.getPrimaryColor();
    final isDailyReminder = await SharedPreferencesHelper.getIsDailyReminder();
    final dailyReminderTime =
        await SharedPreferencesHelper.getDailyReminderTime();

    if (currentLanguage != null) {
      S.load(Locale(currentLanguage.code));
    }

    emit(state.copyWith(
      language: currentLanguage,
      themeMode: themeMode,
      primaryColor: primaryColor,
      isDailyReminder: isDailyReminder,
      dailyReminderTime: dailyReminderTime,
    ));
  }

  void changeLanguage({required Language language}) async {
    await SharedPreferencesHelper.setCurrentLanguage(language);
    S.load(Locale(language.code));
    emit(state.copyWith(
      language: language,
    ));
  }

  void changeThemeMode({required ThemeMode themeMode}) async {
    await SharedPreferencesHelper.setTheme(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  void changePrimaryColor(
      {required Color color, required String hexColor}) async {
    await SharedPreferencesHelper.setPrimaryColor(color);
    await widgetService.updateWidgetColor('#$hexColor');
    emit(state.copyWith(primaryColor: color));
  }

  void changeDynamicColor({required bool isDynamicColor}) {
    emit(state.copyWith(isDynamicColor: isDynamicColor));
  }

  void changeDailyReminder({required bool isDailyReminder}) async {
    await SharedPreferencesHelper.setIsDailyReminder(isDailyReminder);
    emit(state.copyWith(isDailyReminder: isDailyReminder));
    if (isDailyReminder) {
      final time = state.dailyReminderTime.split(':');
      NotiService().scheduleDailyNotification(
        title: S.current.daily_reminder,
        body: S.current.daily_reminder_description,
        hour: int.parse(time[0]),
        minute: int.parse(time[1]),
      );
    } else {
      NotiService().cancelAllNotifications();
    }
  }

  void changeDailyReminderTime({required String dailyReminderTime}) async {
    await SharedPreferencesHelper.setDailyReminderTime(dailyReminderTime);
    emit(state.copyWith(dailyReminderTime: dailyReminderTime));
    if (state.isDailyReminder) {
      final time = dailyReminderTime.split(':');
      NotiService().scheduleDailyNotification(
        title: S.current.daily_reminder,
        body: S.current.daily_reminder_description,
        hour: int.parse(time[0]),
        minute: int.parse(time[1]),
      );
    }
  }
}

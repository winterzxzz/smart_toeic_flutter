import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
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
    final isReminderWordAfterTime =
        await SharedPreferencesHelper.getIsReminderWordAfterTime();
    final reminderWordAfterTime =
        await SharedPreferencesHelper.getReminderWordAfterTime();

    if (currentLanguage != null) {
      S.load(Locale(currentLanguage.code));
    }

    emit(state.copyWith(
      language: currentLanguage,
      themeMode: themeMode,
      primaryColor: primaryColor,
      isDailyReminder: isDailyReminder,
      dailyReminderTime: dailyReminderTime,
      isReminderWordAfterTime: isReminderWordAfterTime,
      reminderWordAfterTime: reminderWordAfterTime,
    ));
  }

  void changeLanguage({required Language language}) async {
    await SharedPreferencesHelper.setCurrentLanguage(language);
    S.load(Locale(language.code));
    if (state.isDailyReminder && state.dailyReminderTime != null) {
      final time = state.dailyReminderTime!.split(':');
      injector<NotiService>().scheduleDailyNotification(
        title: S.current.daily_reminder,
        body: S.current.daily_reminder_description,
        hour: int.parse(time[0]),
        minute: int.parse(time[1]),
      );
    }
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
    emit(state.copyWith(primaryColor: color));
  }

  void changeDynamicColor({required bool isDynamicColor}) {
    emit(state.copyWith(isDynamicColor: isDynamicColor));
  }

  void changeDailyReminder({required bool isDailyReminder}) async {
    await SharedPreferencesHelper.setIsDailyReminder(isDailyReminder);
    emit(state.copyWith(isDailyReminder: isDailyReminder));
    if (isDailyReminder && state.dailyReminderTime != null) {
      final time = state.dailyReminderTime!.split(':');
      injector<NotiService>().scheduleDailyNotification(
        title: S.current.daily_reminder,
        body: S.current.daily_reminder_description,
        hour: int.parse(time[0]),
        minute: int.parse(time[1]),
      );
    } else {
      // Cancel all notifications if daily reminder is turned off
      await SharedPreferencesHelper.removeDailyReminderTime();
      injector<NotiService>().cancelAllNotifications();
    }
  }

  void changeDailyReminderTime({required String dailyReminderTime}) async {
    await SharedPreferencesHelper.setDailyReminderTime(dailyReminderTime);
    emit(state.copyWith(dailyReminderTime: dailyReminderTime));
    if (state.isDailyReminder) {
      final time = dailyReminderTime.split(':');
      await injector<NotiService>().scheduleDailyNotification(
        title: S.current.daily_reminder,
        body: S.current.daily_reminder_description,
        hour: int.parse(time[0]),
        minute: int.parse(time[1]),
      );
    }
  }

  void changeReminderWordAfterTime(
      {required String reminderWordAfterTime}) async {
    await SharedPreferencesHelper.setReminderWordAfterTime(
      reminderWordAfterTime,
    );
    if (state.isReminderWordAfterTime) {
      injector<WidgetService>().updateReminderWordAfterTime(
        reminderWordAfterTime: reminderWordAfterTime,
      );
      emit(state.copyWith(
        reminderWordAfterTime: reminderWordAfterTime,
      ));
    }
  }

  void changeIsReminderWordAfterTime(
      {required bool isReminderWordAfterTime}) async {
    if (isReminderWordAfterTime) {
      injector<WidgetService>().updateReminderWordAfterTime(
        reminderWordAfterTime: state.reminderWordAfterTime,
      );
    } else {
      injector<WidgetService>().cancelWidgetUpdate();
    }
    await SharedPreferencesHelper.setIsReminderWordAfterTime(
      isReminderWordAfterTime,
    );
    emit(state.copyWith(isReminderWordAfterTime: isReminderWordAfterTime));
  }
}

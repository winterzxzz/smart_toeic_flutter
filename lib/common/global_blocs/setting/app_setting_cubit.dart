import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';

import '../../configs/app_configs.dart';
import '../../../data/database/share_preferences_helper.dart';
import '../../../data/models/enums/language.dart';

part 'app_setting_state.dart';

class AppSettingCubit extends Cubit<AppSettingState> {
  AppSettingCubit() : super(const AppSettingState());

  Future<void> getInitialSetting() async {
    final currentLanguage = await SharedPreferencesHelper.getCurrentLanguage();
    final themeMode = await SharedPreferencesHelper.getTheme();
    final isUseBiometric = await SharedPreferencesHelper.getIsUseBiometric();
    final primaryColor = await SharedPreferencesHelper.getPrimaryColor();

    if (currentLanguage != null) {
      S.load(Locale(currentLanguage.code));
    }

    emit(state.copyWith(
      language: currentLanguage,
      themeMode: themeMode,
      isUseBiometric: isUseBiometric,
      primaryColor: primaryColor,
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

  void changeIsUseBiometric({required bool isUseBiometric}) async {
    await SharedPreferencesHelper.setIsUseBiometric(isUseBiometric);
    emit(state.copyWith(isUseBiometric: isUseBiometric));
  }

  void addNavigationHistory({required String path}) {
    emit(state.copyWith(
      navigationHistory: [...state.navigationHistory, path],
      currentPath: path,
    ));
  }

  void removeNavigationHistory() {
    final currentPath = state.navigationHistory.last;
    final newNavigationHistory = state.navigationHistory
        .where((element) => element != currentPath)
        .toList();
    emit(state.copyWith(
      navigationHistory: newNavigationHistory,
      currentPath: newNavigationHistory.last,
    ));
  }

  void clearNavigationHistory() {
    emit(state.copyWith(navigationHistory: const []));
  }

  void setCurrentPath({required String path}) {
    emit(state.copyWith(currentPath: path));
  }

  void changePrimaryColor({required Color color}) async {
    await SharedPreferencesHelper.setPrimaryColor(color);
    emit(state.copyWith(primaryColor: color));
  }

  void changeDynamicColor({required bool isDynamicColor}) {
    emit(state.copyWith(isDynamicColor: isDynamicColor));
  }
}

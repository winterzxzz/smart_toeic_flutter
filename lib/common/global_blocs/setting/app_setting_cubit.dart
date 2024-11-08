import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/start_with.dart';

import '../../configs/app_configs.dart';
import '../../../data/database/share_preferences_helper.dart';
import '../../../data/models/enums/language.dart';

part 'app_setting_state.dart';

class AppSettingCubit extends Cubit<AppSettingState> {
  AppSettingCubit() : super(const AppSettingState());

  Future<int> getInitialSetting() async {
    final currentLanguage = await SharedPreferencesHelper.getCurrentLanguage();
    final themeMode = await SharedPreferencesHelper.getTheme();
    final startWith = await SharedPreferencesHelper.getStartWith();
    final isUseBiometric = await SharedPreferencesHelper.getIsUseBiometric();

    emit(state.copyWith(
      language: currentLanguage,
      themeMode: themeMode,
      startWith: startWith,
      isUseBiometric: isUseBiometric,
    ));
    return startWith.index;
  }

  void changeLanguage({required Language language}) async {
    await SharedPreferencesHelper.setCurrentLanguage(language);
    emit(state.copyWith(
      language: language,
    ));
  }

  void changeThemeMode({required ThemeMode themeMode}) async {
    await SharedPreferencesHelper.setTheme(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  void changeStartWith({required StartWith startWith}) async {
    await SharedPreferencesHelper.setStartWith(startWith);
    emit(state.copyWith(startWith: startWith));
  }

  void changeIsUseBiometric({required bool isUseBiometric}) async {
    await SharedPreferencesHelper.setIsUseBiometric(isUseBiometric);
    emit(state.copyWith(isUseBiometric: isUseBiometric));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/utils/string_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums/language.dart';

class SharedPreferencesHelper {
  static const _firstRunKey = 'first_run';
  static const _isOnboardedKey = 'is_onboarded';
  static const _currentLanguageKey = 'current_language';
  static const _userId = 'sendbird_user_id';
  static const _theme = 'theme';
  static const _isUseBiometric = 'is_use_biometric';
  static const _cookie = 'cookie';

  static Future<bool> isOnboarded() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isOnboardedKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setOnboarded({bool isOnboarded = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardedKey, isOnboarded);
  }

  static Future<Language?> getCurrentLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_currentLanguageKey) ?? "";
      return LanguageExt.languageFromCode(languageCode);
    } catch (e) {
      return null;
    }
  }

  static Future<void> setCurrentLanguage(Language language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentLanguageKey, language.code);
  }

  static Future<ThemeMode> getTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final theme = prefs.getString(_theme) ?? "system";
      return theme.toThemeMode();
    } catch (e) {
      return ThemeMode.system;
    }
  }

  static Future<void> setTheme(ThemeMode theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_theme, theme.name);
  }

  static Future<bool> getIsUseBiometric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isUseBiometric) ?? false;
  }

  static Future<void> setIsUseBiometric(bool isUseBiometric) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isUseBiometric, isUseBiometric);
  }

  // Test

  SharedPreferencesHelper._();

  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._();

  factory SharedPreferencesHelper() => _instance;

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  bool isFirstRun() {
    return _prefs.getBool(_firstRunKey) ?? true;
  }

  Future<void> setFirstRun({bool isFirstRun = true}) async {
    await _prefs.setBool(_firstRunKey, isFirstRun);
  }

  Future<bool> saveSendbirdUserId(String sendbirdId) async {
    return await _prefs.setString(_userId, sendbirdId);
  }

  String getSendBirdUserId() {
    return _prefs.getString(_userId) ?? '';
  }

  Future<bool> removeSendBirdUserId() async {
    return await _prefs.remove(_userId);
  }

  Future<void> storeCookies(Map<String, String> cookieMap) async {
    final cookiesJson = jsonEncode(cookieMap);
    await _prefs.setString(_cookie, cookiesJson);
  }

  String? getCookies() {
    final cookiesJson = _prefs.getString(_cookie);
    if (cookiesJson != null) {
      final cookieMap = jsonDecode(cookiesJson) as Map<String, dynamic>;
      return cookieMap.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return null;
  }

  Future<void> removeCookies() async {
    await _prefs.remove(_cookie);
  }
}

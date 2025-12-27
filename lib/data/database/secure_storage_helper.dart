import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toeic_desktop/app.dart';

import 'share_preferences_helper.dart';

class SecureStorageHelper {
  // The value stored in SecureStore will not be deleted when the app is uninstalled.
  static const _apiTokenKey = 'api_token';
  static const _userIdKey = 'user_id';
  static const _cookieKey = 'cookie';
  static const _biometricEnabledKey = 'biometric_enabled';

  final FlutterSecureStorage _storage;

  SecureStorageHelper._(this._storage);

  static final SecureStorageHelper _instance =
      SecureStorageHelper._(const FlutterSecureStorage());

  static SecureStorageHelper get instance => _instance;

  //Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _apiTokenKey, value: token);
  }

  //Remove token
  Future<void> removeToken() async {
    await _storage.delete(key: _apiTokenKey);
  }

  //Get token
  Future<String?> getToken() async {
    try {
      //If it is the first time opening the app after installation, the value in SecureStore will be deleted.
      final isFirstRun = injector<SharedPreferencesHelper>().isFirstRun();
      if (isFirstRun) {
        removeToken();
        return null;
      }
      final tokenEncoded = await _storage.read(key: _apiTokenKey);
      if (tokenEncoded == null) {
        return null;
      }
      return tokenEncoded;
    } catch (e) {
      return null;
    }
  }

  Future<void> setUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      if (userId == null) {
        return null;
      }
      return userId;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  Future<void> storeCookies(Map<String, String> cookieMap) async {
    final cookiesJson = jsonEncode(cookieMap);
    await _storage.write(key: _cookieKey, value: cookiesJson);
  }

  Future<String?> getCookies() async {
    final cookiesJson = await _storage.read(key: _cookieKey);
    if (cookiesJson != null) {
      final cookieMap = jsonDecode(cookiesJson) as Map<String, dynamic>;
      return cookieMap.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return null;
  }

  Future<void> removeCookies() async {
    await _storage.delete(key: _cookieKey);
  }

  // Biometric authentication methods
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> getBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> removeBiometricEnabled() async {
    await _storage.delete(key: _biometricEnabledKey);
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'share_preferences_helper.dart';

class SecureStorageHelper {
  // The value stored in SecureStore will not be deleted when the app is uninstalled.
  static const _apiTokenKey = 'api_token';
  static const _userIdKey = 'user_id';

  final FlutterSecureStorage _storage;

  SecureStorageHelper._(this._storage);

  static final SecureStorageHelper _instance =
      SecureStorageHelper._(const FlutterSecureStorage());

  static SecureStorageHelper get instance => _instance;

  //Save token
  void saveToken(String token) async {
    await _storage.write(key: _apiTokenKey, value: token);
  }

  //Remove token
  void removeToken() async {
    await _storage.delete(key: _apiTokenKey);
  }

  //Get token
  Future<String?> getToken() async {
    try {
      //If it is the first time opening the app after installation, the value in SecureStore will be deleted.
      final isFirstRun = await SharedPreferencesHelper.isFirstRun();
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

  void setUserId(String userId) async {
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

  void removeUserId() async {
    await _storage.delete(key: _userIdKey);
  }
}

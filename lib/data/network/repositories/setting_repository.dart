import '../api_config/api_client.dart';

abstract class SettingRepository {}

class SettingRepositoryImpl implements SettingRepository {
  ApiClient apiClient;

  SettingRepositoryImpl({required this.apiClient});
}

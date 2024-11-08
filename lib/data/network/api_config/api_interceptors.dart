import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/route_config.dart';
import '../../../common/utils/logger.dart';
import '../../database/secure_storage_helper.dart';

class ApiInterceptors extends QueuedInterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageHelper.instance.getToken();
    options.headers['Accept'] = 'application/json';
    if (token != null) {
      logger.d('token: $token');
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;
    logger.e(
        "⚠️ ERROR[$statusCode] => PATH: $path \n Response: ${err.response?.data}");
    switch (statusCode) {
      case 401:
        SecureStorageHelper.instance.removeToken();
        GoRouter.of(AppRouter.navigationKey.currentContext!)
            .pushReplacementNamed(AppRouter.splash);
        handler.next(err);
      default:
        handler.next(err);
    }
  }
}

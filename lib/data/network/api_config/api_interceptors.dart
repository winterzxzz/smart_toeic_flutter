import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';

import '../../../common/utils/logger.dart';

class ApiInterceptors extends QueuedInterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.headers.forEach((name, values) async {
      if (name == HttpHeaders.setCookieHeader) {
        final cookieMap = <String, String>{};

        for (var c in values) {
          var key = '';
          var value = '';

          key = c.substring(0, c.indexOf('='));
          value = c.substring(key.length + 1, c.indexOf(';'));

          logger.d('cookie: $key = $value');

          cookieMap[key] = value;
        }
        SharedPreferencesHelper().storeCookies(cookieMap);
        return;
      }
    });
    super.onResponse(response, handler);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final cookie = SharedPreferencesHelper().getCookies();
    options.headers['Accept'] = 'application/json';
    options.headers[HttpHeaders.cookieHeader] = cookie;
    if (cookie != null) {
      logger.d('cookie: $cookie');
      options.headers[HttpHeaders.cookieHeader] = cookie;
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
        SharedPreferencesHelper().removeCookies();
        GoRouter.of(AppRouter.navigationKey.currentContext!)
            .go(AppRouter.login);
        handler.next(err);
      default:
        handler.next(err);
    }
  }
}

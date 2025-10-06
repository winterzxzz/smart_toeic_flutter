import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_config/api_interceptors.dart';

class DioClient {
  static Dio createNewDio() {
    return Dio()
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..interceptors.add(ApiInterceptors())
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          compact: false));
  }
}

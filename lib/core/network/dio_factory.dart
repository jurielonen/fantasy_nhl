import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'error_interceptor.dart';
import 'retry_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio createWebApiDio() =>
      _createDio(ApiConstants.nhlWebApiBaseUrl);

  static Dio createStatsApiDio() =>
      _createDio(ApiConstants.nhlStatsApiBaseUrl);

  static Dio _createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.defaultTimeout,
        receiveTimeout: ApiConstants.defaultTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }

    dio.interceptors.add(RetryInterceptor(dio: dio));
    dio.interceptors.add(ErrorInterceptor());

    return dio;
  }
}

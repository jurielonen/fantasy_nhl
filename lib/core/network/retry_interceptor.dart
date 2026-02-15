import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

    if (!_shouldRetry(err) || retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    final delay = initialDelay * (1 << retryCount); // 1s, 2s, 4s
    await Future<void>.delayed(delay);

    err.requestOptions.extra['retryCount'] = retryCount + 1;
    try {
      final response = await dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse =>
        (err.response?.statusCode ?? 0) >= 500,
      _ => false,
    };
  }
}

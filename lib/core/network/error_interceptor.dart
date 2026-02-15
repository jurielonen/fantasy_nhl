import 'package:dio/dio.dart';

import 'api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapException(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  ApiException _mapException(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        ApiException.timeout(message: err.message),
      DioExceptionType.connectionError =>
        ApiException.network(message: err.message),
      DioExceptionType.badResponse =>
        _mapStatusCode(err.response?.statusCode, err.message),
      _ => ApiException.unknown(message: err.message, error: err.error),
    };
  }

  ApiException _mapStatusCode(int? statusCode, String? message) {
    return switch (statusCode) {
      401 => ApiException.unauthorized(message: message),
      404 => ApiException.notFound(message: message),
      final code? when code >= 500 =>
        ApiException.server(statusCode: code, message: message),
      _ => ApiException.unknown(message: message),
    };
  }
}

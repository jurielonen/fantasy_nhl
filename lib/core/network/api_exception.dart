import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

@freezed
sealed class ApiException with _$ApiException implements Exception {
  const factory ApiException.network({String? message}) = NetworkException;
  const factory ApiException.timeout({String? message}) = TimeoutException;
  const factory ApiException.server({
    required int statusCode,
    String? message,
  }) = ServerException;
  const factory ApiException.unauthorized({String? message}) =
      UnauthorizedException;
  const factory ApiException.notFound({String? message}) = NotFoundException;
  const factory ApiException.unknown({String? message, Object? error}) =
      UnknownApiException;
}

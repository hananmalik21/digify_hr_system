/// Base exception for all API-related errors
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode, super.originalError});
}

/// Server error exceptions (5xx)
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode, super.originalError});
}

/// Client error exceptions (4xx)
class ClientException extends AppException {
  const ClientException(super.message, {super.statusCode, super.originalError});
}

/// Unauthorized exception (401)
class UnauthorizedException extends ClientException {
  const UnauthorizedException(super.message, {super.statusCode, super.originalError});
}

/// Forbidden exception (403)
class ForbiddenException extends ClientException {
  const ForbiddenException(super.message, {super.statusCode, super.originalError});
}

/// Not found exception (404)
class NotFoundException extends ClientException {
  const NotFoundException(super.message, {super.statusCode, super.originalError});
}

/// Validation exception (422)
class ValidationException extends ClientException {
  final Map<String, dynamic>? errors;

  const ValidationException(super.message, {super.statusCode, super.originalError, this.errors});
}

/// Timeout exception
class TimeoutException extends NetworkException {
  const TimeoutException(super.message, {super.statusCode, super.originalError});
}

/// Connection exception
class ConnectionException extends NetworkException {
  const ConnectionException(super.message, {super.statusCode, super.originalError});
}

/// Unknown exception
class UnknownException extends AppException {
  const UnknownException(super.message, {super.statusCode, super.originalError});
}

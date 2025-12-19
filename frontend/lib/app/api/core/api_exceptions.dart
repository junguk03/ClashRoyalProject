class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'No internet connection'])
      : super(statusCode: 0);
}

class TimeoutException extends ApiException {
  TimeoutException([super.message = 'Request timeout'])
      : super(statusCode: 408);
}

class BadRequestException extends ApiException {
  BadRequestException([super.message = 'Bad request'])
      : super(statusCode: 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Unauthorized'])
      : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException([super.message = 'Forbidden'])
      : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'Not found'])
      : super(statusCode: 404);
}

class TooManyRequestsException extends ApiException {
  TooManyRequestsException([super.message = 'Too many requests'])
      : super(statusCode: 429);
}

class ServerException extends ApiException {
  ServerException(super.message, {int? statusCode})
      : super(statusCode: statusCode ?? 500);
}

class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException([super.message = 'Service temporarily unavailable'])
      : super(statusCode: 503);
}

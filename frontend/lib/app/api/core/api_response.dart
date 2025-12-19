/// API 응답 모델
class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final T? data;
  final String? message;
  final String? reason;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.message,
    this.reason,
  });

  factory ApiResponse.success({
    required T data,
    int statusCode = 200,
    String? message,
  }) {
    return ApiResponse(
      success: true,
      statusCode: statusCode,
      data: data,
      message: message ?? 'Success',
    );
  }

  factory ApiResponse.error({
    required int statusCode,
    required String message,
    String? reason,
  }) {
    return ApiResponse(
      success: false,
      statusCode: statusCode,
      message: message,
      reason: reason,
    );
  }

  bool get hasData => data != null;
  bool get isError => !success;
}

/// Clash Royale API 에러 응답
class ClientError {
  final String reason;
  final String message;
  final String? type;

  ClientError({
    required this.reason,
    required this.message,
    this.type,
  });

  factory ClientError.fromJson(Map<String, dynamic> json) {
    return ClientError(
      reason: json['reason'] ?? '',
      message: json['message'] ?? '',
      type: json['type'],
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import 'api_exceptions.dart';
import 'api_response.dart';

/// Clash Royale API 클라이언트
class ApiClient extends GetxService {
  late http.Client _client;

  static ApiClient get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    _client = http.Client();
  }

  Map<String, String> get _headers => ApiConfig.defaultHeaders;

  /// GET 요청
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      log.d('GET Request: $uri');

      final response = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST 요청
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      log.d('POST Request: $uri');
      log.d('Request Body: ${json.encode(body)}');

      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 재시도 로직이 포함된 요청
  Future<ApiResponse<T>> requestWithRetry<T>(
    Future<ApiResponse<T>> Function() request, {
    int maxAttempts = 3,
  }) async {
    ApiException? lastException;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await request();
      } on ApiException catch (e) {
        lastException = e;

        // 4xx 에러는 재시도하지 않음
        if (e.statusCode != null &&
            e.statusCode! >= 400 &&
            e.statusCode! < 500) {
          rethrow;
        }

        if (attempt < maxAttempts - 1) {
          await Future.delayed(ApiConfig.retryDelays[attempt]);
          log.d('Retrying request... Attempt ${attempt + 2}/$maxAttempts');
        }
      }
    }

    throw lastException ??
        ApiException('Request failed after $maxAttempts attempts');
  }

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    final url = '${ApiConfig.baseUrl}$endpoint';

    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = Uri(
        queryParameters: queryParams.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      ).query;
      return Uri.parse('$url?$queryString');
    }

    return Uri.parse(url);
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    _logResponse(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _parseSuccessResponse<T>(response, fromJson);
    }

    _throwErrorResponse(response);
  }

  void _logResponse(http.Response response) {
    log.d('═══════════════════════════════════════════════════');
    log.d('Response Status: ${response.statusCode}');
    log.d('Response Body: ${response.body}');
    log.d('═══════════════════════════════════════════════════');
  }

  ApiResponse<T> _parseSuccessResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final jsonData = response.body.isNotEmpty
          ? json.decode(response.body)
          : <String, dynamic>{};

      // Extract 'data' field from backend response if it exists
      final dataToProcess = jsonData is Map && jsonData.containsKey('data')
          ? jsonData['data']
          : jsonData;

      return ApiResponse<T>(
        success: true,
        statusCode: response.statusCode,
        data: fromJson != null && dataToProcess != null
            ? fromJson(
                dataToProcess is Map
                    ? dataToProcess as Map<String, dynamic>
                    : {'data': dataToProcess},
              )
            : dataToProcess,
        message: 'Request successful',
      );
    } catch (e) {
      log.e('Failed to parse response: ${e.toString()}');
      throw ApiException(
        'Failed to parse response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  Never _throwErrorResponse(http.Response response) {
    log.e('ERROR Response received');
    final errorData = _extractErrorData(response);

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(errorData.message);
      case 401:
        throw UnauthorizedException(errorData.message);
      case 403:
        throw ForbiddenException(errorData.message);
      case 404:
        throw NotFoundException(errorData.message);
      case 429:
        throw TooManyRequestsException(errorData.message);
      case 500:
        throw ServerException(errorData.message, statusCode: 500);
      case 503:
        throw ServiceUnavailableException(errorData.message);
      default:
        throw ApiException(errorData.message, statusCode: response.statusCode);
    }
  }

  ClientError _extractErrorData(http.Response response) {
    try {
      final errorJson = json.decode(response.body);
      return ClientError.fromJson(errorJson);
    } catch (_) {
      return ClientError(
        reason: 'unknown',
        message: response.body.isNotEmpty
            ? response.body
            : response.reasonPhrase ?? 'Request failed',
      );
    }
  }

  ApiException _handleError(Object error) {
    if (error is ApiException) {
      return error;
    } else if (error is SocketException) {
      return NetworkException('No internet connection');
    } else if (error is http.ClientException) {
      return NetworkException('Network error: ${error.message}');
    } else if (error is FormatException) {
      return ApiException('Invalid response format');
    } else {
      return ApiException(error.toString());
    }
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }
}

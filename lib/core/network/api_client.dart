import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    Dio? dio,
  }) {
    _dio = dio ?? Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownException(
        'Unexpected error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownException(
        'Unexpected error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownException(
        'Unexpected error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownException(
        'Unexpected error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (response.data == null || response.data.toString().isEmpty) {
        return {};
      }

      // Handle different response types
      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      } else if (response.data is String) {
        return jsonDecode(response.data) as Map<String, dynamic>;
      } else {
        return {'data': response.data};
      }
    } else {
      throw ServerException(
        'Server error: ${response.statusCode} - ${response.data}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Maps DioException to appropriate AppException
  AppException _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Connection timeout. Please check your internet connection.',
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return ConnectionException(
          'Connection error. Please check your internet connection.',
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'Certificate error. Please check your connection.',
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          'Request cancelled',
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.badResponse:
        return _mapHttpStatusError(statusCode, responseData, error);

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true ||
            error.message?.contains('Network is unreachable') == true) {
          return ConnectionException(
            'No internet connection. Please check your network.',
            statusCode: statusCode,
            originalError: error,
          );
        }
        return UnknownException(
          error.message ?? 'Unknown error occurred',
          statusCode: statusCode,
          originalError: error,
        );
    }
  }

  /// Maps HTTP status codes to appropriate exceptions
  AppException _mapHttpStatusError(
    int? statusCode,
    dynamic responseData,
    DioException originalError,
  ) {
    final message = _extractErrorMessage(responseData);

    switch (statusCode) {
      case 400:
        // Check if it's a validation error (has errors array/map)
        final validationErrors = _extractValidationErrors(responseData);
        if (validationErrors != null && validationErrors.isNotEmpty) {
          return ValidationException(
            message ?? 'Validation failed',
            statusCode: statusCode,
            originalError: originalError,
            errors: validationErrors,
          );
        }
        return ClientException(
          message ?? 'Bad request',
          statusCode: statusCode,
          originalError: originalError,
        );
      case 401:
        return UnauthorizedException(
          message ?? 'Unauthorized. Please login again.',
          statusCode: statusCode,
          originalError: originalError,
        );
      case 403:
        return ForbiddenException(
          message ?? 'Access forbidden',
          statusCode: statusCode,
          originalError: originalError,
        );
      case 404:
        return NotFoundException(
          message ?? 'Resource not found',
          statusCode: statusCode,
          originalError: originalError,
        );
      case 422:
        return ValidationException(
          message ?? 'Validation error',
          statusCode: statusCode,
          originalError: originalError,
          errors: _extractValidationErrors(responseData),
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message ?? 'Server error. Please try again later.',
          statusCode: statusCode,
          originalError: originalError,
        );
      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ClientException(
            message ?? 'Client error',
            statusCode: statusCode,
            originalError: originalError,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message ?? 'Server error',
            statusCode: statusCode,
            originalError: originalError,
          );
        }
        return UnknownException(
          message ?? 'Unknown error',
          statusCode: statusCode,
          originalError: originalError,
        );
    }
  }

  /// Extracts error message from response data
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map<String, dynamic>) {
      // Check for validation errors array first
      final errors = responseData['errors'];
      if (errors != null) {
        if (errors is List && errors.isNotEmpty) {
          // Join all error messages
          return errors.map((e) => e.toString()).join(', ');
        } else if (errors is Map && errors.isNotEmpty) {
          // Join all error messages from map
          return errors.values.map((e) => e.toString()).join(', ');
        }
      }
      
      return responseData['message'] as String? ??
          responseData['error'] as String? ??
          responseData['msg'] as String?;
    }

    if (responseData is String) {
      try {
        final decoded = jsonDecode(responseData);
        if (decoded is Map<String, dynamic>) {
          // Check for validation errors array first
          final errors = decoded['errors'];
          if (errors != null) {
            if (errors is List && errors.isNotEmpty) {
              return errors.map((e) => e.toString()).join(', ');
            } else if (errors is Map && errors.isNotEmpty) {
              return errors.values.map((e) => e.toString()).join(', ');
            }
          }
          
          return decoded['message'] as String? ??
              decoded['error'] as String? ??
              decoded['msg'] as String?;
        }
      } catch (_) {
        return responseData;
      }
    }

    return responseData.toString();
  }

  /// Extracts validation errors from response data
  Map<String, dynamic>? _extractValidationErrors(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map<String, dynamic>) {
      final errors = responseData['errors'];
      if (errors != null) {
        if (errors is Map<String, dynamic>) {
          return errors;
        } else if (errors is List) {
          // Convert list to map for easier handling
          final errorMap = <String, dynamic>{};
          for (var i = 0; i < errors.length; i++) {
            errorMap['error_$i'] = errors[i];
          }
          return errorMap;
        }
      }
      return responseData['validation'] as Map<String, dynamic>?;
    }

    if (responseData is String) {
      try {
        final decoded = jsonDecode(responseData);
        if (decoded is Map<String, dynamic>) {
          final errors = decoded['errors'];
          if (errors != null) {
            if (errors is Map<String, dynamic>) {
              return errors;
            } else if (errors is List) {
              // Convert list to map for easier handling
              final errorMap = <String, dynamic>{};
              for (var i = 0; i < errors.length; i++) {
                errorMap['error_$i'] = errors[i];
              }
              return errorMap;
            }
          }
          return decoded['validation'] as Map<String, dynamic>?;
        }
      } catch (_) {
        // Ignore
      }
    }

    return null;
  }

  void dispose() {
    _dio.close();
  }
}

// Logging Interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ Query Parameters: ${options.queryParameters}');
      }
      debugPrint('└─────────────────────────────────────────────────────────');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└─────────────────────────────────────────────────────────');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint('│ ERROR: ${err.type}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('│ Response: ${err.response?.data}');
      debugPrint('│ Status Code: ${err.response?.statusCode}');
      debugPrint('└─────────────────────────────────────────────────────────');
    }
    super.onError(err, handler);
  }
}

// Error Interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can add custom error handling here
    // For example, refresh tokens, retry logic, etc.
    
    // Handle 401 Unauthorized - could trigger token refresh
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic if needed
      if (kDebugMode) {
        debugPrint('Unauthorized - Token may need refresh');
      }
    }

    // Handle 500 Internal Server Error - could retry
    if (err.response?.statusCode == 500) {
      // TODO: Implement retry logic if needed
      if (kDebugMode) {
        debugPrint('Server error - Consider retry');
      }
    }

    super.onError(err, handler);
  }
}


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
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
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
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
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
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
      throw ApiException(
        'Server error: ${response.statusCode} - ${response.data}',
      );
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?.toString() ?? 'Unknown error';
        return 'Server error: $statusCode - $message';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.badCertificate:
        return 'Certificate error';
      case DioExceptionType.unknown:
        return error.message ?? 'Unknown error occurred';
    }
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

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

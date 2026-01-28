import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:gnsa/core/config/config.dart';
import 'package:gnsa/core/services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/dio_api/utils/device_service.dart';
import 'package:gnsa/dio_api/utils/device_udid.dart';

/// Lớp quản lý các yêu cầu HTTP với Dio
class DioApi {
  final Dio dio;
  final DeviceService deviceService = DeviceService();

  DioApi() : dio = Dio() {
    dio.options.baseUrl = Config.baseUrl;
    dio.options.validateStatus = (status) => status != null && status < 500;
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, hander) async {
        final services = await Services.create();
        final accessToken = await services.getAccessToken();
        if (accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return hander.next(options);
      }),
    );
  }

  /// Lấy headers chung cho tất cả request
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final services = await Services.create();
    final deviceUdid = await DeviceUdid.createDeviceUdid();
    final accessToken = await services.getAccessToken();
    final deviceInfo = await deviceService.getDeviceInfo();
    print('accessToken: $accessToken');
    return {
      'accept': '*/*',
      'Content-Type': isMultipart ? 'multipart/form-data' : 'application/json',
      'X_API_ID': 'VN_CREW_2017',
      'X_API_KEY': 'KE4Sc6zqaaHHlpkzStfdpwcmnkvposK6',
      'X_REQUEST_API_VERSION': '5.0',
      'X_REQUEST_UDID': deviceInfo.udid,
      'X_REQUEST_PLATFORM': deviceInfo.platform,
      'X_REQUEST_DEVICE_NAME': deviceInfo.deviceName,
      'X_REQUEST_DEVICE_TYPE': deviceInfo.deviceType,
      'X_REQUEST_OS_VERSION': deviceInfo.osVersion,
      'X_APP_ID': deviceInfo.appId,
      'X_APP_BUILD': deviceInfo.appBuild,
      'X_APP_VERSION': deviceInfo.appVersion,
      'X_PUSH_TOKEN': deviceInfo.pushToken,
      'X_DEVICE_UDID': await deviceUdid.getUdid(),
    };
  }

  /// Chuẩn hoá URL để tránh nhân đôi baseUrl khi truyền full URL
  String _resolveUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    final base = dio.options.baseUrl;
    if (base.endsWith('/') && url.startsWith('/')) {
      return '$base${url.substring(1)}';
    }
    if (!base.endsWith('/') && !url.startsWith('/')) {
      return '$base/$url';
    }
    return '$base$url';
  }

  /// Log request details
  void _logRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    final fullUrl = _resolveUrl(url);
    final safeHeaders = Map<String, String>.from(headers);
    if (safeHeaders.containsKey('Authorization')) {
      safeHeaders['Authorization'] = '[HIDDEN]';
    }

    print('═══════════════════════════════════════════════════════════');
    print('📤 API REQUEST - $method');
    print('URL: $fullUrl');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      print('Query Parameters: $queryParameters');
    }
    print('Headers: $safeHeaders');
    if (data != null) {
      print('Request Data: $data');
    }
    if (data != null) {
      debugPrint('Request Data (FULL):');
      _logFullJson(data);
    }
    print('═══════════════════════════════════════════════════════════');
  }

  /// Log response details
  void _logResponse({
    required String method,
    required String url,
    required Response response,
  }) {
    final fullUrl = _resolveUrl(url);
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('📥 API RESPONSE - $method');
    debugPrint('URL: $fullUrl');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Status Message: ${response.statusMessage}');
    debugPrint('Headers: ${response.headers}');
    debugPrint('Response Data (FULL):');
    _logFullJson(response.data);
    debugPrint('═══════════════════════════════════════════════════════════');
  }

  /// Log error details
  void _logError({
    required String method,
    required String url,
    required dynamic error,
    DioException? dioException,
  }) {
    final fullUrl = _resolveUrl(url);
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('❌ API ERROR - $method');
    debugPrint('URL: $fullUrl');
    if (dioException != null) {
      debugPrint('Error Type: ${dioException.type}');
      debugPrint('Error Message: ${dioException.message}');
      debugPrint('Response: ${dioException.response?.data}');
      debugPrint('Status Code: ${dioException.response?.statusCode}');
      debugPrint('Response Headers: ${dioException.response?.headers}');
    } else {
      debugPrint('Error: $error');
    }
    debugPrint('═══════════════════════════════════════════════════════════');
  }

  /// Log JSON theo chunks để tránh bị cắt trên console
  void _logFullJson(dynamic data) {
    try {
      final encoder = const JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(data);

      const chunkSize = 800; // an toàn cho console Flutter
      for (var i = 0; i < prettyJson.length; i += chunkSize) {
        final end = (i + chunkSize < prettyJson.length)
            ? i + chunkSize
            : prettyJson.length;
        debugPrint(prettyJson.substring(i, end));
      }
    } catch (e) {
      debugPrint('⚠️ Cannot pretty print json: $e');
      debugPrint(data.toString());
    }
  }

  /// Gửi yêu cầu GET
  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    dynamic data,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);

      _logRequest(
        method: 'GET',
        url: url,
        headers: headers,
        data: data,
        queryParameters: params,
      );

      final response = await dio.get(
        url,
        queryParameters: params,
        data: data,
        options: mergedOptions,
        cancelToken: cancelToken,
      );

      _logResponse(
        method: 'GET',
        url: url,
        response: response,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      _logError(
        method: 'GET',
        url: url,
        error: e,
        dioException: e,
      );
      throw Exception('Failed to load data: ${e.message}');
    } catch (e) {
      _logError(
        method: 'GET',
        url: url,
        error: e,
      );
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi yêu cầu POST
  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    bool isMultipart = false,
  }) async {
    try {
      final headers = await _getHeaders(isMultipart: isMultipart);
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);

      _logRequest(
        method: 'POST',
        url: url,
        headers: headers,
        data: data,
      );

      final response = await dio.post(
        url,
        data: data,
        options: mergedOptions,
      );

      _logResponse(
        method: 'POST',
        url: url,
        response: response,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      _logError(
        method: 'POST',
        url: url,
        error: e,
        dioException: e,
      );
      throw Exception('Failed to post data: ${e.message}');
    } catch (e) {
      _logError(
        method: 'POST',
        url: url,
        error: e,
      );
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi yêu cầu PUT
  Future<Response> put(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);

      _logRequest(
        method: 'PUT',
        url: url,
        headers: headers,
        data: data,
      );

      final response = await dio.put(
        url,
        data: data,
        options: mergedOptions,
      );

      _logResponse(
        method: 'PUT',
        url: url,
        response: response,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      _logError(
        method: 'PUT',
        url: url,
        error: e,
        dioException: e,
      );
      throw Exception('Failed to update data: ${e.message}');
    } catch (e) {
      _logError(
        method: 'PUT',
        url: url,
        error: e,
      );
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi yêu cầu DELETE
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);

      _logRequest(
        method: 'DELETE',
        url: url,
        headers: headers,
        queryParameters: params,
      );

      final response = await dio.delete(
        url,
        queryParameters: params,
        options: mergedOptions,
      );

      _logResponse(
        method: 'DELETE',
        url: url,
        response: response,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      _logError(
        method: 'DELETE',
        url: url,
        error: e,
        dioException: e,
      );
      throw Exception('Failed to delete data: ${e.message}');
    } catch (e) {
      _logError(
        method: 'DELETE',
        url: url,
        error: e,
      );
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi yêu cầu PATCH
  Future<Response> patch(
    String url, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);

      _logRequest(
        method: 'PATCH',
        url: url,
        headers: headers,
        data: data,
      );

      final response = await dio.patch(
        url,
        data: data,
        options: mergedOptions,
      );

      _logResponse(
        method: 'PATCH',
        url: url,
        response: response,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      _logError(
        method: 'PATCH',
        url: url,
        error: e,
        dioException: e,
      );
      throw Exception('Failed to patch data: ${e.message}');
    } catch (e) {
      _logError(
        method: 'PATCH',
        url: url,
        error: e,
      );
      throw Exception('Unexpected error: $e');
    }
  }

  /// Xử lý phản hồi từ server
  Response _handleResponse(Response response) {
    if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
      return response;
    }
    throw Exception(
        'Error: ${response.statusCode} - ${response.statusMessage}');
  }
}

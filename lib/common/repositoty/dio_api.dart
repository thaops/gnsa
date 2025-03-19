// import 'package:app_version_update/core/values/consts/consts.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/Services/config.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/common/repositoty/device_service.dart';
import 'package:gnsa/common/repositoty/device_udid.dart';


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
  }

  /// Lấy các headers chung cho tất cả request
  Future<Map<String, String>> _getHeaders() async {
    final services = await Services.create();
    final deviceUdid = await DeviceUdid.createDeviceUdid();
    final accessToken = await services.getAccessToken();
    final deviceInfo = await deviceService.getDeviceInfo();
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      "X_API_ID": "VN_CREW_2017", //Required
      "X_API_KEY": "KE4Sc6zqaaHHlpkzStfdpwcmnkvposK6", //Required
      "X_REQUEST_API_VERSION": "5.0", //Required
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
    return headers;
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? data,
      CancelToken? cancelToken,
       Options? options}) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);
      final response = await dio.get(
        url,
        queryParameters: params,
        data: data,
        options: mergedOptions,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Response> post(String url, {dynamic data, Options? options}) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ??
          Options(headers: headers);
      final response = await dio.post(
        url,
        data: data,
        options: mergedOptions,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception('Failed to post data: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    try {
      final headers = await _getHeaders();
      final response = await dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception('Failed to update data: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Response> delete(String url, {Map<String, dynamic>? params}) async {
    try {
      final headers = await _getHeaders();
      final response = await dio.delete(
        url,
        queryParameters: params,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception('Failed to delete data: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

    Future<Response> patch(String url, {dynamic data, Options? options}) async {
    try {
      final headers = await _getHeaders();
      final mergedOptions = options?.copyWith(
            headers: {...?options.headers, ...headers},
          ) ?? 
          Options(headers: headers);
      final response = await dio.patch(
        url,
        data: data,
        options: mergedOptions,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception('Failed to patch data: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Response _handleResponse(Response response) {
    if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
      return response;
    } else {
      throw Exception(
          'Error: ${response.statusCode} - ${response.statusMessage}');
    }
  }
}

final dioApiProvider = Provider((ref) => DioApi());

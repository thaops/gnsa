import 'package:dio/dio.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';

class DioApi {
  final Dio dio = Dio()..options.validateStatus = (status) => status! < 500;

  // Phương thức GET với tham số tên
  Future<Response> get(String url, {Map<String, dynamic>? params, Map<String, dynamic>? data,CancelToken? cancelToken}) async {
    final services = await Services.create();
    final accessToken = await services.getAccessToken();
    try {
      final response = await dio.get(
        url,
        queryParameters: params, // Truyền tham số tên
        data: data,        
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // Phương thức POST với tham số tên
  Future<Response> post(String url, {dynamic data, Options? options}) async {
    final services = await Services.create();
    final accessToken = await services.getAccessToken();
    try {
      final response = await dio.post(
        url,
        data: data, // Chấp nhận dynamic để có thể truyền FormData
        options: options ?? Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  // Phương thức PUT với tham số tên
  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    final services = await Services.create();
    final accessToken = await services.getAccessToken();
    try {
      final response = await dio.put(
        url,
        data: data, // Truyền tham số tên
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  // Phương thức DELETE với tham số tên
  Future<Response> delete(String url, {Map<String, dynamic>? params}) async {
    final services = await Services.create();
    final accessToken = await services.getAccessToken();
    try {
      final response = await dio.delete(
        url,
        queryParameters: params, // Truyền tham số tên
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  // Xử lý phản hồi
  Response _handleResponse(Response response) {
    if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
      return response; // Trả về phản hồi nếu thành công
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.statusMessage}');
    }
  }
}


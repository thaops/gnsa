import 'package:dio/dio.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/dio_api/dio_api.dart';
import 'package:gnsa/feature/auth/data/model/login_request_model.dart';
import 'package:gnsa/feature/auth/data/model/login_response_model.dart';

abstract class LoginRemoteDataSources {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel);
}

class LoginRemoteDataSourcesImpl implements LoginRemoteDataSources {
  final DioApi _dioApi;
  LoginRemoteDataSourcesImpl(this._dioApi);
  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    try {
      final response = await _dioApi.post(
        ApiEndpoints.login,
        data: loginRequestModel.toJson(),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Khi API trả về statusCode != 200, _handleResponse sẽ throw exception
      // Nhưng response.data vẫn có thể được lấy từ DioException
      if (e.response != null && e.response!.data != null) {
        print('⚠️ Login API returned error, parsing response data...');
        return LoginResponseModel.fromJson(e.response!.data);
      }
      // Nếu không có response data, throw lại exception
      rethrow;
    } catch (e) {
      // Nếu không phải DioException, throw lại
      rethrow;
    }
  }
}
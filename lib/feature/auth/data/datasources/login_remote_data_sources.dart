import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
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
    final response = await _dioApi.post(
      ApiEndpoints.login,
      data: loginRequestModel.toJson(),
    );
    print("response.data: ${response.data}");
    return LoginResponseModel.fromJson(response.data);
  }
}
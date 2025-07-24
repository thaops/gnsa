import 'package:gnsa/feature/auth/data/datasources/login_remote_data_sources.dart';
import 'package:gnsa/feature/auth/data/model/login_request_model.dart';
import 'package:gnsa/feature/auth/data/model/login_response_model.dart';
import 'package:gnsa/feature/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSources remoteDataSources;

  LoginRepositoryImpl(this.remoteDataSources);

  @override
  Future<LoginResponseModel> login(String userName, String password) async {
    final requestModel =
        LoginRequestModel(userName: userName, password: password);
    return await remoteDataSources.login(requestModel);
  }
}

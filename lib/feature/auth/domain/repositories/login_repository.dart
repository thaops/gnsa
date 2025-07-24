import 'package:gnsa/feature/auth/data/model/login_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login(String userName, String password);
}

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponseModel> call(String userName, String password) async {
    return await repository.login(userName, password);
  }

  Future<LoginResponseModel> execute(String userName, String password) async {
    return await repository.login(userName, password);
  }
}
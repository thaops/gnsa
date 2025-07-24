class LoginRequestModel {
  final String userName;
  final String password;

  LoginRequestModel({
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserName': userName,
      'Password': password,
    };
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      userName: json['UserName'] as String,
      password: json['Password'] as String,
    );
  }
}
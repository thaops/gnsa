class LoginResponseModel {
  final String accessToken;
  final int statusCode;
  final String? message;

  LoginResponseModel({
    required this.accessToken,
    required this.statusCode,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['Data']['AccessToken'],
      statusCode: json['StatusCode'],
      message: json['Message'],
    );
  }

  
}
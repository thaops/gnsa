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
    // Xử lý trường hợp Data có thể là null
    String accessToken = '';
    if (json['Data'] != null && json['Data'] is Map) {
      accessToken = json['Data']['AccessToken'] ?? '';
    }
    
    return LoginResponseModel(
      accessToken: accessToken,
      statusCode: json['StatusCode'] ?? 400,
      message: json['Message'],
    );
  }

  
}
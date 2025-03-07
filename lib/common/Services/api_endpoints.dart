// lib/common/config/api_endpoints.dart
import 'package:gnsa/common/Services/config.dart';

class ApiEndpoints {
  static const String login = "${Config.baseUrl}/user/login";
  static const String flightList = "${Config.baseUrl}/flight/get-flights";
}

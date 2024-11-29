// lib/common/config/api_endpoints.dart
import 'package:gnsa/common/Services/config.dart';

class ApiEndpoints {
  static const String login = "${Config.baseUrl}/login";
  static const String getBrand = "${Config.baseUrl}/brands";
  static const String getCategory = "${Config.baseUrl}/category";
  static const String subcategory = "${Config.baseUrl}/subcategory/type/components";

  // products
  static const String products = "${Config.baseUrl}/products";
  static const String productPagination = "${Config.baseUrl}/products/pagination";
}

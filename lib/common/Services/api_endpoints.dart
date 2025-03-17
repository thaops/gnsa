// lib/common/config/api_endpoints.dart
import 'package:gnsa/common/Services/config.dart';

class ApiEndpoints {
  static const String login = "${Config.baseUrl}/user/login";
  static const String flightList = "${Config.baseUrl}/flight/flights";
  static String flightDetail(String id) => "${Config.baseUrl}/flight/mobile/flight-detail/$id";
  static String supplyFormAllDetail({String? id, int? pageIndex, int? pageSize}) => "${Config.baseUrl}/supplyform/mobile/get-all-by-flight?flightId=$id&pageIndex=${pageIndex ?? 1}&pageSize=${pageSize ?? 100}";
  static String supplyFormDetail({ String? supplyFormId , String? supplyFormType }) => "${Config.baseUrl}/supplyform/mobile/get-detail-by-flight?supplyFormId=$supplyFormId&supplyFormType=$supplyFormType";
  static String getSignedSupplyForm({ String? supplyFormId}) => "${Config.baseUrl}/supplyform/mobile/get-signed/$supplyFormId";
  static const String signedForm = "${Config.baseUrl}/supplyform/mobile/signed-form";
  static const String updateSupplyFormNote = "${Config.baseUrl}/supplyform/mobile/update-note";
}
 
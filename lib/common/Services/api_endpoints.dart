// lib/common/config/api_endpoints.dart
import 'package:gnsa/common/Services/config.dart';

class ApiEndpoints {
  static const String login = "${Config.baseUrl}/user/login";
  static String flightList = "${Config.baseUrl}/flight/mobile/flights";
  static String flightDetail(String id) =>
      "${Config.baseUrl}/flight/mobile/flight-detail/$id";
  // static String supplyFormAllDetail({String? id, int? pageIndex, int? pageSize}) => "${Config.baseUrl}/supplyform/mobile/get-all-by-flight?flightId=$id&pageIndex=${pageIndex ?? 1}&pageSize=${pageSize ?? 100}";
  static String supplyFormDetail(
          {String? supplyFormId, String? supplyFormType}) =>
      "${Config.baseUrl}/supplyform/mobile/get-detail-by-flight?supplyFormId=$supplyFormId&supplyFormType=$supplyFormType";
  static String getSignedSupplyForm({String? supplyFormId}) =>
      "${Config.baseUrl}/supplyform/mobile/get-signed/$supplyFormId";
  static const String signedForm =
      "${Config.baseUrl}/supplyform/mobile/signed-form";
  static const String updateSupplyFormNote =
      "${Config.baseUrl}/supplyform/mobile/update-note";



//new
//supplyfromdetail
  static String supplyFormAllDetail({String? id}) =>
      "${Config.baseUrl}/supplyform/get-supply-form-detail-by-flight-id-mobile?flightId=$id";
  static String updateSupplyfromItemDetail =
      "${Config.baseUrl}/supplyform/update-item-in-supply-form-mobile";
  static String getSupplyfromItemDetail =
      "${Config.baseUrl}/supplyform/get-item-in-supply-form-mobile";

  //cart
  static String addCart = "${Config.baseUrl}/cart/add-cart-to-supply-form";
  static String getListCart = "${Config.baseUrl}/cart/get-list-cart";

  static String getFlightPreview = "${Config.baseUrl}/supplyform/preview-supply-form-in-mobile";
  //signed
  static String getListSignedSupplyForm(String supplyFormDetailId) => "${Config.baseUrl}/supplyform/get-list-signed-supply-form-mobile?supplyFormDetailId=$supplyFormDetailId";
  static String signedSupplyForm = "${Config.baseUrl}/supplyform/signed-supply-form-mobile";
}

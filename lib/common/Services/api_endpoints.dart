import 'package:gnsa/core/config/config.dart';

class ApiEndpoints {
  static const String login = "${Config.baseUrl}/user/login";
  static String flightList =
      "${Config.baseUrl}/flightinfo/get-list-flight-4mobile";
  static String flightDetail(String id) =>
      "${Config.baseUrl}/flightinfo/get-list-flight-4mobile/$id";
  static String supplyFormDetail(
          {String? supplyFormId, String? supplyFormType}) =>
      "${Config.baseUrl}/supplyform/mobile/get-detail-by-flight?supplyFormId=$supplyFormId&supplyFormType=$supplyFormType";
  static String getSignedSupplyForm({String? supplyFormId}) =>
      "${Config.baseUrl}/supplyform/mobile/get-signed/$supplyFormId";
  static const String signedForm =
      "${Config.baseUrl}/supplyform/mobile/signed-form";
  static const String updateSupplyFormNote =
      "${Config.baseUrl}/supplyform/mobile/update-note";

  static String supplyFormAllDetail({String? id}) =>
      "${Config.baseUrl}/supplyform/mobile/get-supply-form-detail/$id";
  static String updateSupplyfromItemDetail =
      "${Config.baseUrl}/supplyform/mobile/update-item-in-supply-form";
  static String getSupplyfromItemDetail =
      "${Config.baseUrl}/supplyform/mobile/get-item-in-supply-form";

  static String addCart = "${Config.baseUrl}/cart/add-cart-to-supply-form";
  static String getListCart = "${Config.baseUrl}/cart/get-list-cart";

  static String getFlightPreview(String flightId, {List<String>? types}) {
    final baseUrl =
        "${Config.baseUrl}/supplyform/mobile/preview-supply-form/$flightId";
    if (types == null || types.isEmpty) {
      return baseUrl;
    }
    final typesParam = types.map((t) => 'types=$t').join('&');
    return "$baseUrl?$typesParam";
  }

  static String getListSignedSupplyForm(String supplyFormDetailId) =>
      "${Config.baseUrl}/supplyform/mobile/get-signed-supply-form?supplyFormDetailId=$supplyFormDetailId";
  static String signedSupplyForm =
      "${Config.baseUrl}/supplyform/mobile/signed-in-supply-form";

  static String qr(String flightId) =>
      "${Config.baseUrl}/supplyform/mobile/get-qr-code-by-flight/$flightId";

  static String getSupplyType =
      "${Config.baseUrl}/supplyform/mobile/get-supply-type";
}

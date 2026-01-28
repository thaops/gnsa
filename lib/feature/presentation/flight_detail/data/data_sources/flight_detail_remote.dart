import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/dio_api/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_add_req_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_item_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supply_type_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';

abstract class FlightDetailRemote {
  Future<SupplyFormModel> getFlightDetail(String id);
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req);

  Future<FlightPreviewModel> getFlightPreview(PreviewArgs args);

  Future<List<CardItemModel>> getListCart();

  Future<bool> addCardItem(CardAddReqModel req);

  Future<String> getQr(String flightId);

  Future<List<SupplyTypeModel>> getSupplyTypes();
}

class FlightDetailRemoteImpl implements FlightDetailRemote {
  final DioApi _dioApi;
  FlightDetailRemoteImpl(this._dioApi);
  @override
  Future<SupplyFormModel> getFlightDetail(String id) async {
    final response =
        await _dioApi.get(ApiEndpoints.supplyFormAllDetail(id: id));
    return SupplyFormModel.fromJson(
        response.data['Data'] as Map<String, dynamic>);
  }

  @override
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req) async {
    final response = await _dioApi.patch(
      ApiEndpoints.updateSupplyfromItemDetail,
      data: req.toJson(),
    );
    return response.data['Data'] as String;
  }

  @override
  Future<FlightPreviewModel> getFlightPreview(PreviewArgs args) async {
    final response = await _dioApi.get(
      ApiEndpoints.getFlightPreview(args.flightId, types: args.type),
    );
    print("response.data['Data'] ${response.data['Data']}");

    return FlightPreviewModel.fromJson(
        response.data['Data'] as Map<String, dynamic>);
  }

  @override
  Future<List<CardItemModel>> getListCart() async {
    final response = await _dioApi.get(ApiEndpoints.getListCart);
    return (response.data['Data'] as List)
        .map((e) => CardItemModel.fromJson(e))
        .toList();
  }

  @override
  Future<bool> addCardItem(CardAddReqModel req) async {
    final response =
        await _dioApi.post(ApiEndpoints.addCart, data: req.toJson());
    return response.data['Data'] as bool;
  }

  @override
  Future<String> getQr(String flightId) async {
    print("Calling QR API with flightId: $flightId");

    try {
      final response = await _dioApi.get(ApiEndpoints.qr(flightId));
      print("QR API response: ${response.data}");

      // Check if response has data and Data field
      if (response.data == null) {
        print("QR API response data is null");
        return '';
      }

      if (!response.data.containsKey('Data')) {
        print(
            "QR API response does not contain 'Data' field. Available keys: ${response.data.keys}");
        return '';
      }

      final data = response.data['Data'];
      print("QR API Data field: $data");
      print("QR API Data field type: ${data.runtimeType}");

      // Handle different possible data types
      if (data == null) {
        print("QR API Data field is null");
        return '';
      }

      if (data is String) {
        print("QR API Data is already a string: '$data'");
        return data;
      }

      // If it's not a string, try to convert it
      final result = data.toString();
      print("QR API Data converted to string: '$result'");
      return result;
    } catch (e, stack) {
      print("Exception in getQr: $e");
      print("Stack trace: $stack");
      return '';
    }
  }

  @override
  Future<List<SupplyTypeModel>> getSupplyTypes() async {
    final response = await _dioApi.get(ApiEndpoints.getSupplyType);
    return (response.data['Data'] as List)
        .map((e) => SupplyTypeModel.fromJson(e))
        .toList();
  }
}

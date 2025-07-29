import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_add_req_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_item_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';

abstract class FlightDetailRemote {
  Future<SupplyFormModel> getFlightDetail(String id);
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req);

  Future<FlightPreviewModel> getFlightPreview(PreviewArgs args);

  Future<List<CardItemModel>> getListCart();

  Future<bool> addCardItem(CardAddReqModel req);

  Future<String> getQr(String flightId);

}

class FlightDetailRemoteImpl implements FlightDetailRemote {
  final DioApi _dioApi;
  FlightDetailRemoteImpl(this._dioApi);
  @override
  Future<SupplyFormModel> getFlightDetail(String id) async {
    final response = await _dioApi.get(ApiEndpoints.supplyFormAllDetail(id: id));
    print("response.data['Data'] ${response.data['Data']}");
    return SupplyFormModel.fromJson(response.data['Data'] as Map<String, dynamic>);
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
    final response = await _dioApi.post(ApiEndpoints.getFlightPreview, data: args.toJson());
    return FlightPreviewModel.fromJson(response.data['Data'] as Map<String, dynamic>);
  }

  @override
  Future<List<CardItemModel>> getListCart() async {
    final response = await _dioApi.get(ApiEndpoints.getListCart);
    return (response.data['Data'] as List).map((e) => CardItemModel.fromJson(e)).toList();
  }

  @override
  Future<bool> addCardItem(CardAddReqModel req) async {
    final response = await _dioApi.post(ApiEndpoints.addCart, data: req.toJson());
    return response.data['Data'] as bool;
  }

  @override
  Future<String> getQr(String flightId) async {
    final response = await _dioApi.get(ApiEndpoints.qr(flightId));
    return response.data['Data'] as String;
  }
}
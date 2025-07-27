import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';

abstract class FlightDetailRemote {
  Future<SupplyFormModel> getFlightDetail(String id);
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req);

  Future<FlightPreviewModel> getFlightPreview(String id);
}

class FlightDetailRemoteImpl implements FlightDetailRemote {
  final DioApi _dioApi;
  FlightDetailRemoteImpl(this._dioApi);
  @override
  Future<SupplyFormModel> getFlightDetail(String id) async {
    final response = await _dioApi.get(ApiEndpoints.supplyFormAllDetail(id: id));
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
  Future<FlightPreviewModel> getFlightPreview(String flightId) async {
    final response = await _dioApi.get(ApiEndpoints.getFlightPreview(flightId));
    return FlightPreviewModel.fromJson(response.data['Data'] as Map<String, dynamic>);
  }
}
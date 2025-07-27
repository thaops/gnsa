import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';

abstract class FlightSignatureRemote {
  Future<SignSupplyfrom> getSignSupplyfrom(String supplyFormDetailId);
}

class FlightSignatureRemoteImpl implements FlightSignatureRemote {
  final DioApi _dioApi;
  FlightSignatureRemoteImpl(this._dioApi);
  @override
  Future<SignSupplyfrom> getSignSupplyfrom(String supplyFormDetailId) async {
    final response = await _dioApi.get(ApiEndpoints.getListSignedSupplyForm(supplyFormDetailId));
    final data = SignSupplyfrom.fromJson(response.data['Data']);
    return data;
  }
}
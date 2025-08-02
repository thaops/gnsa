import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_req.dart';

abstract class FlightSignRemote {
  Future<String> saveSignature(FlightSignReq req);
}

class FlightSignRemoteImpl implements FlightSignRemote {
  final DioApi _dioApi;
  FlightSignRemoteImpl(this._dioApi);
  @override
  Future<String> saveSignature(FlightSignReq req) async {
    print("req: ${req.toJson()}");
    final response = await _dioApi.post(
      ApiEndpoints.signedSupplyForm,
      data: await req.toFormData(),
      isMultipart: true,
    );
    print("responsesss: $response");
    
    return response.data['Data'] as String;
  }
}

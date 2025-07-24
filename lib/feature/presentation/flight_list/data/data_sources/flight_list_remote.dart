import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_params.dart';

abstract class FlightListRemote {
  Future<FlightsModel> getFlights(FlightsParams flightsParams);
}

class FlightListRemoteImpl implements FlightListRemote {
  final DioApi _dioApi;
  FlightListRemoteImpl(this._dioApi);
  @override
  Future<FlightsModel> getFlights(FlightsParams flightsParams) async {
    final response = await _dioApi.get(ApiEndpoints.flightList,
        params: flightsParams.toQueryParams());
    return FlightsModel.fromJson(response.data);
  }
}
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_params.dart';

abstract class FlightListReponsitory {
  Future<FlightsModel> getFlights(FlightsParams flightsParams);
}

class FlightUserCase {
  final FlightListReponsitory repository;

  FlightUserCase(this.repository);

  Future<FlightsModel> call(FlightsParams flightsParams) async {
    return await repository.getFlights(flightsParams);
  }
}
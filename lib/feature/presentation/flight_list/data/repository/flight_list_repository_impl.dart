import 'package:gnsa/feature/presentation/flight_list/data/data_sources/flight_list_remote.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_params.dart';
import 'package:gnsa/feature/presentation/flight_list/domain/reponsitory/flight_list_reponsitory.dart';

class FlightListRepositoryImpl implements FlightListReponsitory {
  final FlightListRemote _flightListRemote;
  FlightListRepositoryImpl(this._flightListRemote);

  @override
  Future<FlightsModel> getFlights(FlightsParams flightsParams) async {
    return await _flightListRemote.getFlights(flightsParams);
  }
}
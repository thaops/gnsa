import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_req.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/remote/flight_sign_remote.dart';
import 'package:gnsa/feature/presentation/flight_sign/domain/flight_sign_reponsitory.dart';

class FlightSignReponsitoryImpl implements FlightSignReponsitory {
  final FlightSignRemote _flightSignRemote;
  FlightSignReponsitoryImpl(this._flightSignRemote);

  @override
  Future<bool> saveSignature(FlightSignReq req) async {
    final response = await _flightSignRemote.saveSignature(req);
    return response.isNotEmpty;
  }
}
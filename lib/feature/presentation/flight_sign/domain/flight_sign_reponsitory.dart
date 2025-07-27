import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_req.dart';

abstract class FlightSignReponsitory {
  Future<bool> saveSignature(FlightSignReq req);
}

class FlightSignUserCase {
  final FlightSignReponsitory repository;
  FlightSignUserCase(this.repository);

  Future<bool> saveSignature(FlightSignReq req) async {
    return await repository.saveSignature(req);
  }
}

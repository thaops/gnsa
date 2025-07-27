import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/remote/flight_signature_remote.dart';
abstract class FlightSignatureReponsitory {
  Future<SignSupplyfrom> getSignSupplyfrom(String supplyFormDetailId);
}
class FlightSignatureReponsitoryImpl implements FlightSignatureReponsitory {
  final FlightSignatureRemote _flightSignatureRemote;
  FlightSignatureReponsitoryImpl(this._flightSignatureRemote);
  @override
  Future<SignSupplyfrom> getSignSupplyfrom(String supplyFormDetailId) {
    return _flightSignatureRemote.getSignSupplyfrom(supplyFormDetailId);
  }
}
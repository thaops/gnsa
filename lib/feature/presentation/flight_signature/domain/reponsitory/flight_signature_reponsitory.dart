import 'package:gnsa/feature/presentation/flight_signature/data/flight_signature_rep_ipml.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';


class FlightSignatureUserCase {
  final FlightSignatureReponsitory repository;
  FlightSignatureUserCase(this.repository);

  Future<SignSupplyfrom> getSignSupplyfrom(String supplyFormDetailId) {
    return repository.getSignSupplyfrom(supplyFormDetailId);
  }
}

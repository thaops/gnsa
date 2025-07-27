import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/Services/services_base/api_service_ref.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/flight_signature_rep_ipml.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/remote/flight_signature_remote.dart';
import 'package:gnsa/feature/presentation/flight_signature/domain/reponsitory/flight_signature_reponsitory.dart';

final flightSignatureRemoteProvider = Provider<FlightSignatureRemote>((ref) {
  return FlightSignatureRemoteImpl(ref.read(dioApiProvider));
});

final flightSignatureRepositoryProvider = Provider<FlightSignatureReponsitory>((ref) {
  return FlightSignatureReponsitoryImpl(ref.read(flightSignatureRemoteProvider));
});
final flightSignatureUserCaseProvider = Provider<FlightSignatureUserCase>((ref) {
  return FlightSignatureUserCase(ref.read(flightSignatureRepositoryProvider));
});
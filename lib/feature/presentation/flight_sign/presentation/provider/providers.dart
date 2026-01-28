import 'package:gnsa/dio_api/providers/dio_provider.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/remote/flight_sign_remote.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/reponsitory/flight_sign_reponsitory_Impl.dart';
import 'package:gnsa/feature/presentation/flight_sign/domain/flight_sign_reponsitory.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flightSignRemoteProvider = Provider<FlightSignRemote>((ref) {
  return FlightSignRemoteImpl(ref.read(dioApiProvider));
});

final flightSignRepositoryProvider = Provider<FlightSignReponsitory>((ref) {
  return FlightSignReponsitoryImpl(ref.read(flightSignRemoteProvider));
});
final flightSignUserCaseProvider = Provider<FlightSignUserCase>((ref) {
  return FlightSignUserCase(ref.read(flightSignRepositoryProvider));
});

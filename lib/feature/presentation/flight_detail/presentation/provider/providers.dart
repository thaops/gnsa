import 'package:flutter_riverpod/legacy.dart';
import 'package:gnsa/dio_api/providers/dio_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/data_sources/flight_detail_remote.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/repository/flight_detail_repository_impl.dart';
import 'package:gnsa/feature/presentation/flight_detail/domain/repository/flight_detail_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flightDetailRemoteProvider = Provider<FlightDetailRemote>((ref) {
  return FlightDetailRemoteImpl(ref.read(dioApiProvider));
});

final flightDetailRepositoryProvider = Provider<FlightDetailRepository>((ref) {
  return FlightDetailRepositoryImpl(ref.read(flightDetailRemoteProvider));
});
final flightDetailUserCaseProvider = Provider<FlightDetailUserCase>((ref) {
  return FlightDetailUserCase(ref.read(flightDetailRepositoryProvider));
});

final flightId = StateProvider<String>((ref) => '');

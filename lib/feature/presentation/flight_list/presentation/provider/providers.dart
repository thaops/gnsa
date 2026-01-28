import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/dio_api/providers/dio_provider.dart';
import 'package:gnsa/feature/presentation/flight_list/data/data_sources/flight_list_remote.dart';
import 'package:gnsa/feature/presentation/flight_list/data/repository/flight_list_repository_impl.dart';
import 'package:gnsa/feature/presentation/flight_list/domain/reponsitory/flight_list_reponsitory.dart';

final flightListRemoteProvider = Provider<FlightListRemote>((ref) {
  return FlightListRemoteImpl(ref.read(dioApiProvider));
});

final flightListRepositoryProvider = Provider<FlightListReponsitory>((ref) {
  return FlightListRepositoryImpl(ref.read(flightListRemoteProvider));
});
final flightUseCaseProvider = Provider<FlightUserCase>((ref) {
  return FlightUserCase(ref.read(flightListRepositoryProvider));
});

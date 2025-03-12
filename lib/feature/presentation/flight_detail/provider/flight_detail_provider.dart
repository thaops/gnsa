// lib/feature/auth/provider/login_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart' show FlightDetailModel;

final flightDetailControllerProvider = StateNotifierProvider<FlightDetailNotifier, AsyncValue<FlightDetailModel>>((ref) {
  return FlightDetailNotifier();
});

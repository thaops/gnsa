import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/feature/presentation/flight_sign/controller/flight_sign_controller.dart';

final flightSignControllerProvider = ChangeNotifierProvider<FlightSignController>((ref) {
  return FlightSignController();
});

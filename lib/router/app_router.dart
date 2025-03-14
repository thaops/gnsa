import 'package:flutter/material.dart';
import 'package:gnsa/feature/auth/view/login.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/flight_detail.dart';
import 'package:gnsa/feature/presentation/flight_list/view/flight_list.dart';
import 'package:gnsa/feature/presentation/flight_signature/view/flight_signature.dart';
import 'package:gnsa/feature/presentation/flight_sign/view/flight_sign.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const login = '/login';
  static const flightList = '/flight-list';
  static const flightDetail = '/flight-detail';
  static const flightSignature = '/flight-signature';
  static const flightSign = '/flight-sign';
  static const flightPrinter = '/flight-printer';

  static GoRouter getRouter(String accessToken) {
    return GoRouter(
      initialLocation: accessToken.isNotEmpty ? flightList : login,
      routes: [
        GoRoute(
          path: login,
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: flightList,
          builder: (context, state) => const FlightList(),
        ),
        GoRoute(
          path: flightDetail,
          builder: (context, state) {
            final id = state.extra as String;
            return FlightDetail(
              id: id,
            );
          },
        ),
        GoRoute(
          path: flightSignature,
          builder: (context, state) => const FlightSignature(),
        ),
        GoRoute(
          path: flightSign,
          builder: (context, state) => const FlightSign(
            title: '',
          ),
        ),
        GoRoute(
          path: flightPrinter,
          builder: (context, state) {
            final flightDetailModel = state.extra as FlightDetailModel;
            return FlightPrinter(flightDetailModel: flightDetailModel);
          },
        ),
      ],
    );
  }
}

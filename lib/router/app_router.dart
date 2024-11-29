import 'package:get/get.dart';
import 'package:gnsa/feature/auth/binding/login_binding.dart';
import 'package:gnsa/feature/auth/view/login.dart';
import 'package:gnsa/feature/flight_list/binding/flight_list_binding.dart';
import 'package:gnsa/feature/flight_list/view/flight_list.dart';

class AppRouter {
  static const login = '/login';
  static const flightList = '/flight-list';
  static final List<GetPage> routes = [
    //auth
    GetPage(name: login, page: () => const Login(), binding: LoginBinding()),
    //flight list
    GetPage(name: flightList, page: () => const FlightList(), binding: FlightListBinding()),
  ];
}

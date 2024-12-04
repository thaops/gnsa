import 'package:get/get.dart';
import 'package:gnsa/feature/auth/binding/login_binding.dart';
import 'package:gnsa/feature/auth/view/login.dart';
import 'package:gnsa/feature/presentation/flight_detail/binding/flight_detail_binding.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/flight_detail.dart';
import 'package:gnsa/feature/presentation/flight_list/binding/flight_list_binding.dart';
import 'package:gnsa/feature/presentation/flight_list/view/flight_list.dart';

class AppRouter {
  static const login = '/login';
  static const flightList = '/flight-list';
  static const flightDetail = '/flight-detail';
  static final List<GetPage> routes = [
    //auth
    GetPage(name: login, page: () => const Login(), binding: LoginBinding()),
    //flight list
    GetPage(name: flightList, page: () => const FlightList(), binding: FlightListBinding()),
    //flight detail
    GetPage(name: flightDetail, page: () => const FlightDetail(), binding: FlightDetailBinding()),
  ];
}

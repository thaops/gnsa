import 'package:get/get.dart';
import 'package:gnsa/feature/auth/binding/login_binding.dart';
import 'package:gnsa/feature/auth/view/login.dart';
import 'package:gnsa/feature/presentation/flight_detail/binding/flight_detail_binding.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/flight_detail.dart';
import 'package:gnsa/feature/presentation/flight_list/binding/flight_list_binding.dart';
import 'package:gnsa/feature/presentation/flight_list/view/flight_list.dart';
import 'package:gnsa/feature/presentation/flight_printer/binding/flight_printer_binding.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/feature/presentation/flight_sign/binding/flight_sign_binding.dart';
import 'package:gnsa/feature/presentation/flight_sign/view/flight_sign.dart';
import 'package:gnsa/feature/presentation/flight_signature/view/flight_signature.dart';
import 'package:gnsa/feature/presentation/flight_signature/binding/flight_signature_binding.dart';

class AppRouter {
  static const login = '/login';
  static const flightList = '/flight-list';
  static const flightDetail = '/flight-detail';
  static const flightSignature = '/flight-signature';
  static const flightSign = '/flight-sign';
  static const flightPrinter = '/flight-printer';
  static final List<GetPage> routes = [
    //auth
    GetPage(name: login, page: () => const Login(), binding: LoginBinding()),
    //flight list
    GetPage(
        name: flightList,
        page: () =>  FlightList(),
        binding: FlightListBinding()),
    //flight detail
    GetPage(
        name: flightDetail,
        page: () => const FlightDetail(),
        binding: FlightDetailBinding()),
    //flight signature
    GetPage(
        name: flightSignature,
        page: () => const FlightSignature(),
        binding: FlightSignatureBinding()),
    //flight sign
    GetPage(
        name: flightSign,
        page: () => FlightSign(),
        binding: FlightSignBinding()),
    //flight printer
    GetPage(
        name: flightPrinter,
        page: () => const FlightPrinter(),
        binding: FlightPrinterBinding()),
  ];
}

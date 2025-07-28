import 'package:gnsa/feature/auth/view/login.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/flight_detail.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/preview_view.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/qrcode_view.dart';
import 'package:gnsa/feature/presentation/flight_list/view/flight_list.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_arguments.dart';
import 'package:gnsa/feature/presentation/flight_sign/view/flight_sign.dart';
import 'package:gnsa/feature/presentation/flight_signature/view/flight_signature.dart';
import 'package:gnsa/feature/profile/profile_view.dart';
import 'package:gnsa/router/bottom_navigation_main.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const login = '/login';
  static const flightList = '/flight-list';
  static const flightDetail = '/flight-detail';
  static const flightSignature = '/flight-signature';
  static const flightSign = '/flight-sign';
  static const flightPrinter = '/flight-printer';
  static const main = '/main';
  static const preview = '/preview';
  static const qrcode = '/qrcode';
  static const profile = '/profile';

  static GoRouter getRouter(String accessToken) {
    return GoRouter(
      initialLocation: accessToken.isNotEmpty ? main : login,
      routes: [

        GoRoute(
          name: login,
          path: login,
          builder: (context, state) =>const  LoginScreen(),
        ),
        GoRoute(
          name: main,
          path: main,
          builder: (context, state) => MainScreen(),
        ),
        GoRoute(
          name: flightList,
          path: flightList,
          builder: (context, state) => const FlightListScreen(isMyFlight: false),
        ),
        GoRoute(
          name: preview,
          path: preview,
          builder: (context, state) {
            final args = state.extra as PreviewArgs;
            return PreviewView(
              args: args,
            );
          },
        ),
        GoRoute(
          name: qrcode,
          path: qrcode,
          builder: (context, state) => const QrcodeView(),
        ),
        GoRoute(
          name: flightDetail,
          path: flightDetail,
          builder: (context, state) {
            final id = state.extra as String;
            return FlightDetailScreen(
              id: id,
            );
          },
        ),
        GoRoute(
          name: flightSignature,
          path: flightSignature,
          builder: (context, state) {
           List<String> supplyformdetailId = state.extra as List<String> ;
             return FlightSignature(supplyfromdetailId: supplyformdetailId);
          },
        ),
        GoRoute(
            name: flightSign,
            path: flightSign,
            builder: (context, state) {
              final args = state.extra as FlightSignArguments?;
              return FlightSign(
                arguments: args!,
              );
            }),
        GoRoute(
          name: flightPrinter,
          path: flightPrinter,
          builder: (context, state) {
            final flightDetailModel = state.extra as SupplyFormModel;
            final flightId = state.extra as String;
            return FlightPrinter(flightDetailModel: flightDetailModel, flightId: flightId);
          },
        ),
        GoRoute(
          name: profile,
          path: profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}

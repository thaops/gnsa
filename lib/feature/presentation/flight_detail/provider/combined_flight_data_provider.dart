// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
// import 'package:gnsa/feature/presentation/flight_detail/provider/filght_supplyfrom_provider.dart';

// final combinedFlightDataProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, flightId) async {
//   final flightDetail = await ref.read(flightDetailControllerProvider.notifier).fetchFlightDetail(flightId);
//   final flightSupplyForm = await ref.read(flightSupplyFromProvider.notifier).fetchSupplyForm(flightId);
//   return {
//     'flightDetail': flightDetail,
//     'flightSupplyForm': flightSupplyForm,
//   };
// });
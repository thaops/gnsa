// import 'dart:async';
// import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnsa/common/Services/api_endpoints.dart';
// import 'package:gnsa/common/repositoty/dio_api.dart';
// import 'package:gnsa/feature/presentation/flight_detail/model/supplyform_model.dart';

// class FlightSupplyFormState extends StateNotifier<AsyncValue<List<>>> {
//   FlightSupplyFormState() : super(const AsyncValue.loading());

//   Future<List<SupplyForm>> fetchSupplyForm(String id) async {
//   final dioApi = DioApi();
//   try {
//     state = const AsyncValue.loading();
//     final response = await dioApi.get(ApiEndpoints.supplyFormAllDetail(id: id));

//     if (response.statusCode == HttpStatus.ok) {
//       final data = response.data['Data']['Data'];
//       if (data is List) {
//         final supplyForms = data.map((e) => SupplyForm.fromJson(e)).toList();
//         state = AsyncValue.data(supplyForms);
//         return supplyForms;
//       } else {
//         state = AsyncValue.error('Unexpected data format', StackTrace.current);
//       }
//     } else {
//       state = AsyncValue.error('Failed to fetch data', StackTrace.current);
//     }
//   } catch (e, stackTrace) {
//     state = AsyncValue.error(e, stackTrace);
//   }
//   return [];
// }

// }

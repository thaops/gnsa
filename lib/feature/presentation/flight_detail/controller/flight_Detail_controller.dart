// flight_detail_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import '../model/flight_detail_model.dart';

class FlightDetailNotifier extends StateNotifier<AsyncValue<FlightDetailModel>> {
  FlightDetailNotifier() : super(const AsyncValue.loading());


  Future<FlightDetailModel> fetchFlightDetail(String id) async {
    try {
      state = const AsyncValue.loading(); 
      final dioApi = DioApi();
      final response = await dioApi.get(ApiEndpoints.supplyFormAllDetail(id: id));
      if (response.statusCode == HttpStatus.ok) {
        final data = response.data['Data'];
        state = AsyncValue.data(FlightDetailModel.fromJson(data)); 
        return FlightDetailModel.fromJson(data);
      } else {
        throw Exception('Failed to load flight detail');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace); 
    }
    return FlightDetailModel();
  }
}

final flightDetailControllerProvider =
    StateNotifierProvider<FlightDetailNotifier, AsyncValue<FlightDetailModel>>(
  (ref) => FlightDetailNotifier(),
);

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

        final transformedData = transformSupplies(data);

        final flightDetail = FlightDetailModel.fromJson(transformedData);
        state = AsyncValue.data(flightDetail);
        return flightDetail;
      } else {
        throw Exception('Failed to load flight detail');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      print("Error: $error");
    }
    return FlightDetailModel();
  }

  Map<String, dynamic> transformSupplies(Map<String, dynamic> data) {
    List<dynamic> supplyForms = data['supplyForms'] ?? [];

    for (var form in supplyForms) {
      List<dynamic> supplies = form['Supplies'] ?? [];
      Map<String, List<dynamic>> groupedSupplies = {};

      for (var supply in supplies) {
        String categoryName = supply['CategoryName'] ?? 'Unknown';
        if (!groupedSupplies.containsKey(categoryName)) {
          groupedSupplies[categoryName] = [];
        }
        groupedSupplies[categoryName]!.add(supply);
      }

      List<Map<String, dynamic>> newSupplies = [];
      groupedSupplies.forEach((categoryName, items) {
        newSupplies.add({
          'CategoryName': categoryName,
          'Items': items,
        });
      });

      form['Supplies'] = newSupplies;
    }

    return data;
  }
}

final flightDetailControllerProvider =
    StateNotifierProvider<FlightDetailNotifier, AsyncValue<FlightDetailModel>>(
  (ref) => FlightDetailNotifier(),
);
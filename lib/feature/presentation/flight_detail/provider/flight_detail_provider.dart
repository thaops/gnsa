import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/flight_detail_model.dart';

part 'flight_detail_provider.g.dart'; 

@riverpod
class FlightDetailProvider extends _$FlightDetailProvider {
  @override
  FutureOr<FlightDetailModel> build() async {
    return FlightDetailModel();
  }

  Future<FlightDetailModel> fetchFlightDetail(String id) async {
    try {
      state = const AsyncValue.loading();
      final dioApi = ref.read(dioApiProvider); // Sử dụng provider thay vì khởi tạo trực tiếp
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
      rethrow;
    }
  }

  Map<String, dynamic> transformSupplies(Map<String, dynamic> data) {
    List<dynamic> supplyForms = data['supplyForms'] ?? [];

    for (var form in supplyForms) {
      List<dynamic> supplies = form['Supplies'] ?? [];
      Map<String, List<dynamic>> groupedSupplies = {};

      for (var supply in supplies) {
        String categoryName = supply['CategoryName'] ?? 'Unknown';
        groupedSupplies.putIfAbsent(categoryName, () => []).add(supply);
      }

      form['Supplies'] = groupedSupplies.entries.map((e) => {
        'CategoryName': e.key,
        'Items': e.value,
      }).toList();
    }

    return data;
  }
}
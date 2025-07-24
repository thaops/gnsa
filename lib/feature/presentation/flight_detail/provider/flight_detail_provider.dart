import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/supplyform_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_detail_provider.g.dart';

@riverpod
class FlightDetailProvider extends _$FlightDetailProvider {

  @override
  FutureOr<SupplyFormModel> build() async {
    return SupplyFormModel();
  }

  Future<SupplyFormModel> fetchFlightDetail(String id) async {
    if (!ref.mounted) {
      return SupplyFormModel();
    }

    try {
      state = const AsyncValue.loading();
      final dioApi = ref.read(dioApiProvider);
      final response = await dioApi.get(
        ApiEndpoints.supplyFormAllDetail(id: id),
      );
      print('API response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['Data'];
        final transformedData = transformSupplies(data);
        final flightDetail = SupplyFormModel.fromJson(transformedData);
        if (ref.mounted) {
          state = AsyncValue.data(flightDetail);
        }
        return flightDetail;
      } else {
        final error = Exception('Failed to load flight detail: ${response.statusCode}');
        if (ref.mounted) {
          state = AsyncValue.error(error, StackTrace.current);
        }
        return SupplyFormModel();
      }
    } catch (error, stackTrace) {
      print('Error in fetchFlightDetail: $error');
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
      return SupplyFormModel();
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
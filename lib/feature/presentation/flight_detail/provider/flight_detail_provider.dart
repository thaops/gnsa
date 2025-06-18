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
    fetchFlightDetail('');
    return state.value!;
  }

  Future<FlightDetailModel> fetchFlightDetail(String id) async {

    final fakeFlightDetail = FlightDetailModel(
  flight: Flight(
    flightNo: "VN123",
    routing: "SGN-HAN",
    flightType: "Domestic",
    flightDate: DateTime.parse("2025-06-20T10:00:00"),
    actualTimeDepart: DateTime.parse("2025-06-20T10:15:00"),
    actualTimeArrival: DateTime.parse("2025-06-20T12:30:00"),
  ),
  supplyForms: [
    SupplyForm(
      supplyFormId: "SF001",
      supplyFormCode: "FORM-001",
      category: "Meal",
      className: "Business",
      totalSupply: 30,
      status: "Confirmed",
      supplies: [
        SupplyGroup(
          categoryName: "Food",
          items: [
            SupplyItem(
              supplyFormId: "SF001",
              supplyId: "F001",
              categoryName: "Food",
              supplyName: "Chicken Rice",
              suppliedQuantity: 15,
              confirmedQuantity: 15,
              note: "Delivered on time",
            ),
            SupplyItem(
              supplyFormId: "SF001",
              supplyId: "F002",
              categoryName: "Food",
              supplyName: "Beef Noodle",
              suppliedQuantity: 15,
              confirmedQuantity: 14,
              note: "1 portion missing",
            ),
          ],
        ),
        SupplyGroup(
          categoryName: "Drink",
          items: [
            SupplyItem(
              supplyFormId: "SF001",
              supplyId: "D001",
              categoryName: "Drink",
              supplyName: "Orange Juice",
              suppliedQuantity: 30,
              confirmedQuantity: 30,
              note: "Delivered on time",
            ),
            SupplyItem(
              supplyFormId: "SF001",
              supplyId: "D002",
              categoryName: "Drink",
              supplyName: "Water Bottle",
              suppliedQuantity: 30,
              confirmedQuantity: 30,
              note: "",
            ),
          ],
        ),
      ],
    ),
    SupplyForm(
      supplyFormId: "SF002",
      supplyFormCode: "FORM-002",
      category: "Snack",
      className: "Economy",
      totalSupply: 100,
      status: "Pending",
      supplies: [
        SupplyGroup(
          categoryName: "Snack",
          items: [
            SupplyItem(
              supplyFormId: "SF002",
              supplyId: "S001",
              categoryName: "Snack",
              supplyName: "Cookies",
              suppliedQuantity: 50,
              confirmedQuantity: 0,
              note: "Waiting for confirmation",
            ),
            SupplyItem(
              supplyFormId: "SF002",
              supplyId: "S002",
              categoryName: "Snack",
              supplyName: "Crackers",
              suppliedQuantity: 50,
              confirmedQuantity: 0,
              note: "Waiting for confirmation",
            ),
          ],
        ),
      ],
    ),
  ],
);

    try {
      // state = const AsyncValue.loading();
      // final dioApi = ref.read(dioApiProvider); 
      // final response = await dioApi.get(ApiEndpoints.supplyFormAllDetail(id: id));
      
      // if (response.statusCode == HttpStatus.ok) {
      //   final data = response.data['Data'];
      //   final transformedData = transformSupplies(data);
      //   final flightDetail = FlightDetailModel.fromJson(transformedData);
      //   state = AsyncValue.data(flightDetail);
      //   return flightDetail;
      // } else {
      //   throw Exception('Failed to load flight detail');
      // }
      state = AsyncValue.data(fakeFlightDetail);
      return fakeFlightDetail;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return FlightDetailModel();
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
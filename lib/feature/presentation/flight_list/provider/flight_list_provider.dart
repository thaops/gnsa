// providers/flights_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';


class FlightListNotifier extends AsyncNotifier<FlightsModel> {
  int _pageIndex = 1;
  final int _pageSize = 20;

  @override
  Future<FlightsModel> build() async {
    return await _fetchFlights();
  }

  Future<FlightsModel> _fetchFlights({String? search}) async {
    final dioApi = ref.read(dioApiProvider);
    final response = await dioApi.get(ApiEndpoints.flightList, params: {
      "PageIndex": _pageIndex,
      "PageSize": _pageSize,
      "Keyword": search,
    });
    return FlightsModel.fromJson(response.data);
  }

  Future<void> refreshFlights({String? search}) async {
    _pageIndex = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFlights(search: search));
  }

  Future<void> loadMore({String? search}) async {
    _pageIndex++;
    final moreData = await _fetchFlights(search: search);
    state = AsyncValue.data(
      FlightsModel(
        statusCode: moreData.statusCode,
        message: moreData.message,
        totalRecord: moreData.totalRecord,
        data: [...state.value!.data, ...moreData.data],
      ),
    );
  }
}

final flightListProvider = AsyncNotifierProvider<FlightListNotifier, FlightsModel>(
  () => FlightListNotifier(),
);
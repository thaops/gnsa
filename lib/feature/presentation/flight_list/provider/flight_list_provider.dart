import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';

part 'flight_list_provider.g.dart';

// Hằng số cấu hình
const _defaultPageSize = 20;
const _initialPageIndex = 1;

@riverpod
class FlightListNotifier extends _$FlightListNotifier {
  int _pageIndex = _initialPageIndex;

  final int _pageSize = _defaultPageSize;

  CancelToken _cancelToken = CancelToken();

  FlightsModel? _fullFlights;

  @override
  FutureOr<FlightsModel> build() async {
    _fullFlights = await _fetchFlights();
    return _fullFlights!;
  }

  Future<FlightsModel> _fetchFlights({String? search, bool isMyFlight = false}) async {
    final dioApi = ref.read(dioApiProvider);
    final fakeFlightsModel = FlightsModel(
  statusCode: 200,
  message: "Success",
  totalRecord: 2,
  data: [
    FlightData(
      id: "f001",
      flightNo: "VN123",
      flightDate: DateTime.parse("2025-06-20T10:00:00"),
      actualTimeDepart: DateTime.parse("2025-06-20T10:15:00"),
      actualTimeArrival: DateTime.parse("2025-06-20T12:30:00"),
      routing: "SGN-HAN",
      depart: "SGN",
      arrival: "HAN",
      status: "Arrived",
      airlineCode: "VN",
    ),
    FlightData(
      id: "f002",
      flightNo: "VN456",
      flightDate: DateTime.parse("2025-06-21T14:00:00"),
      actualTimeDepart: DateTime.parse("2025-06-21T14:05:00"),
      actualTimeArrival: DateTime.parse("2025-06-21T16:20:00"),
      routing: "HAN-DAD",
      depart: "HAN",
      arrival: "DAD",
      status: "On Time",
      airlineCode: "VN",
    ),
  ],
);

final fakeFlightsModelRemove = isMyFlight ? fakeFlightsModel.data.removeAt(1) : fakeFlightsModel.data;

    try {
      // final response = await dioApi.get(
      //   ApiEndpoints.flightList,
      //   params: {
      //     'PageIndex': _pageIndex,
      //     'PageSize': _pageSize,
      //     'Keyword': search,
      //   },
      //   cancelToken: _cancelToken,
      // );


      return FlightsModel(
        statusCode: fakeFlightsModel.statusCode,
        message: fakeFlightsModel.message,
        totalRecord: fakeFlightsModel.totalRecord,
        data: fakeFlightsModelRemove as List<FlightData>,
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
      }
      rethrow;
    }
  }

  Future<void> refreshFlights({String? search}) async {
    _cancelToken.cancel('Cancelled due to new request');
    _cancelToken = CancelToken();
    _pageIndex = _initialPageIndex;
    state = const AsyncValue.loading();

    try {
      if (search == null || search.isEmpty) {
        // Sử dụng danh sách đã lưu nếu không có tìm kiếm
        if (_fullFlights != null && ref.mounted) {
          state = AsyncValue.data(_fullFlights!);
        } else {
          _fullFlights = await _fetchFlights();
          if (ref.mounted) {
            state = AsyncValue.data(_fullFlights!);
          }
        }
      } else {
        // Gọi API với từ khóa tìm kiếm
        if (ref.mounted) {
          state = await AsyncValue.guard(() => _fetchFlights(search: search));
        }
      }
    } catch (e) {
      if (ref.mounted) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  /// Tải thêm chuyến bay
  Future<void> loadMore({String? search}) async {
    _pageIndex++;
    try {
      final moreData = await _fetchFlights(search: search);
      if (ref.mounted) {
        state = AsyncValue.data(
          FlightsModel(
            statusCode: moreData.statusCode,
            message: moreData.message,
            totalRecord: moreData.totalRecord,
            data: [...state.value!.data, ...moreData.data],
          ),
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

}

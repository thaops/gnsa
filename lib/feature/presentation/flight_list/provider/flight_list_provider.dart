import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';

part 'flight_list_provider.g.dart';

const _defaultPageSize = 20;
const _initialPageIndex = 1;

@riverpod
class FlightListNotifier extends _$FlightListNotifier {
  int _pageIndex = _initialPageIndex;
  final int _pageSize = _defaultPageSize;
  CancelToken _cancelToken = CancelToken();
  FlightsModel? _fullFlights;
  FlightsModel? _fullFlightsMyFlight;

  @override
  FutureOr<FlightsModel> build() async {
    if (ref.read(isMyFlightProvider)) {
      _fullFlightsMyFlight = await fetchFlights(isMyFlight: true);
      return _fullFlightsMyFlight!;
    } else {
      _fullFlights = await fetchFlights();
      return _fullFlights!;
    }
  }

  Future<FlightsModel> fetchFlights({String? search, bool isMyFlight = false}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('Không có kết nối internet');
    }

    final dioApi = ref.read(dioApiProvider);
    try {
      final response = await dioApi.get(
        ApiEndpoints.flightList(isMySchedule: isMyFlight, pageIndex: _pageIndex, pageSize: _pageSize),
        cancelToken: _cancelToken,
      );

      return FlightsModel(
        statusCode: response.data['StatusCode'],
        message: response.data['Message'],
        totalRecord: response.data['TotalRecord'],
        data: (response.data['Data'] as List<dynamic>)
            .map((item) => FlightData.fromJson(item))
            .toList(),
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        throw Exception('Yêu cầu bị hủy');
      }
      throw Exception('Không thể lấy dữ liệu chuyến bay: $e');
    }
  }

  Future<void> refreshFlights({String? search}) async {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('Hủy do yêu cầu mới');
    }
    _cancelToken = CancelToken();
    _pageIndex = _initialPageIndex;
    state = const AsyncValue.loading();

    try {
      if (ref.read(isMyFlightProvider)) {
        if (search == null || search.isEmpty) {
          if (_fullFlightsMyFlight != null && ref.mounted) {
            print('Using cached _fullFlightsMyFlight');
            state = AsyncValue.data(_fullFlightsMyFlight!);
          } else {
            print('Fetching new my flights');
            _fullFlightsMyFlight = await fetchFlights(isMyFlight: true);
            if (ref.mounted) {
              state = AsyncValue.data(_fullFlightsMyFlight!);
            }
          }
        } else {
          if (ref.mounted) {
            state = await AsyncValue.guard(() => fetchFlights(search: search, isMyFlight: true));
          }
        }
      } else {
        if (search == null || search.isEmpty) {
          if (_fullFlights != null && ref.mounted) {
            state = AsyncValue.data(_fullFlights!);
          } else {
            _fullFlights = await fetchFlights();
            if (ref.mounted) {
              state = AsyncValue.data(_fullFlights!);
            }
          }
        } else {
          if (ref.mounted) {
            state = await AsyncValue.guard(() => fetchFlights(search: search));
          }
        }
      }
    } catch (e) {
      if (ref.mounted) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<void> loadMore({String? search}) async {
    _pageIndex++;
    try {
      final moreData = await fetchFlights(
        search: search,
        isMyFlight: ref.read(isMyFlightProvider),
      );
      if (ref.mounted && moreData != null) {
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

// Provider để theo dõi trạng thái isMyFlight
final isMyFlightProvider = StateProvider<bool>((ref) => false);
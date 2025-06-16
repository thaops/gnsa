import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';

part 'flight_list_provider.g.dart';

// Hằng số cấu hình
const _defaultPageSize = 20;
const _initialPageIndex = 1;

/// Notifier quản lý danh sách chuyến bay với tìm kiếm và tải thêm
@riverpod
class FlightListNotifier extends _$FlightListNotifier {
  /// Chỉ số trang hiện tại
  int _pageIndex = _initialPageIndex;

  /// Kích thước trang
  final int _pageSize = _defaultPageSize;

  /// Token để hủy yêu cầu API
  CancelToken _cancelToken = CancelToken();

  /// Lưu trữ danh sách đầy đủ khi không tìm kiếm
  FlightsModel? _fullFlights;

  @override
  FutureOr<FlightsModel> build() async {
    _fullFlights = await _fetchFlights();
    return _fullFlights!;
  }

  /// Lấy danh sách chuyến bay từ API
  Future<FlightsModel> _fetchFlights({String? search}) async {
    final dioApi = ref.read(dioApiProvider);
    try {
      final response = await dioApi.get(
        ApiEndpoints.flightList,
        params: {
          'PageIndex': _pageIndex,
          'PageSize': _pageSize,
          'Keyword': search,
        },
        cancelToken: _cancelToken,
      );
      return FlightsModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
      }
      rethrow;
    }
  }

  /// Làm mới danh sách chuyến bay
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

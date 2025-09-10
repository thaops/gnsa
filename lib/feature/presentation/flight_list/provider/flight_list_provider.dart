import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_params.dart';
import 'package:gnsa/feature/presentation/flight_list/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_list_provider.g.dart';

@Riverpod(keepAlive: true)
class FlightListNotifier extends _$FlightListNotifier {
  int _page = 1;
  final int _pageSize = 10;
  CancelToken? _cancelToken;
  late bool _isMyFlight;
  bool _isLoadingMore = false;
  FlightsModel? _originalData;
  DateTime? _fromDate;
  DateTime? _toDate;

  // Getter methods for accessing date values
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  @override
  Future<FlightsModel> build(bool isMyFlight) async {
    _isMyFlight = isMyFlight;
    _page = 1;
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result =
        await _fetchFlights(search: null, cancelToken: _cancelToken!);
    _originalData = result;
    return result;
  }

  void restoreOriginalData() {
    if (_originalData != null) {
      state = AsyncValue.data(_originalData!);
    }
  }

  Future<FlightsModel> fetchInitialFlights(
      {String? search, DateTime? fromDate, DateTime? toDate}) async {
    if (!ref.mounted) return FlightsModel();
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    _page = 1;

    // Store the date range for future searches
    _fromDate = fromDate ?? _fromDate;
    _toDate = toDate ?? _toDate;

    return await _fetchFlights(
        search: search,
        fromDate: _fromDate,
        toDate: _toDate,
        cancelToken: _cancelToken!);
  }

  // Future<void> loadMore({String? search}) async {
  //   if (!ref.mounted || state.isLoading) return;
  //   _page++;
  //   print('Page: $_page');
  //   final moreFlights = await _fetchFlights(search: search, cancelToken: _cancelToken!);
  //   if (!ref.mounted) return;
  //   state = AsyncValue.data(state.value!.copyWith(
  //     data: [...state.value?.data ?? [], ...moreFlights.data ?? []],
  //   ));
  // }

  Future<void> loadMore({String? search}) async {
    if (!ref.mounted || _isLoadingMore || (_cancelToken?.isCancelled ?? false))
      return;

    _isLoadingMore = true;
    _page++;

    print('Page: $_page');

    try {
      final moreFlights =
          await _fetchFlights(search: search, cancelToken: _cancelToken!);
      if (!ref.mounted || (_cancelToken?.isCancelled ?? false)) return;
      final data = <FlightData>[
        ...state.value?.data ?? [],
        ...moreFlights.data ?? [],
      ];
      // if (search?.isEmpty ?? true) {
      //   _originalData = FlightsModel(data: data);
      // }
      state = AsyncValue.data(state.value!.copyWith(
        data: data,
      ));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<FlightsModel> _fetchFlights({
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
    required CancelToken cancelToken,
  }) async {
    try {
      final params = FlightsParams(
        pageIndex: _page,
        pageSize: _pageSize,
        isMySchedule: _isMyFlight,
        keyword: search,
        fromDate: fromDate,
        toDate: toDate,
      );
      return await ref.read(flightListRepositoryProvider).getFlights(params);
    } catch (e) {
      if (_page > 1) _page--;
      return FlightsModel();
    }
  }

  Future<void> refreshFlights(
      {String? search, DateTime? fromDate, DateTime? toDate}) async {
    if (!ref.mounted) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchInitialFlights(
        search: search, fromDate: fromDate, toDate: toDate));
  }
}
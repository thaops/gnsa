import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_detail_provider.g.dart';

@riverpod
class FlightDetailProvider extends _$FlightDetailProvider {
  @override
  FutureOr<SupplyFormModel> build(String id,{bool isSkipLoading = false}) async {
    return fetchFlightDetail(id,isSkipLoading: isSkipLoading);
  }

  Future<SupplyFormModel> fetchFlightDetail(String id,{bool isSkipLoading = false}) async {
    if (!ref.mounted) {
      return SupplyFormModel();
    }
    final asyncHander = ref.read(asyncRequestHandlerProvider.notifier);
    return await asyncHander.execute<SupplyFormModel>(
          state: state,
          apiCall: () => ref.read(flightDetailUserCaseProvider).call(id),
          onSuccess: (response) {
            state = AsyncValue.data(response);
          },
          cancelPrevious: true,
          isSkipLoading: isSkipLoading,
        ) ??
        SupplyFormModel();
  }
}

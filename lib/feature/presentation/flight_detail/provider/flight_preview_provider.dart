import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_preview_provider.g.dart';

@riverpod
class FlightPreviewProvider extends _$FlightPreviewProvider {
  @override
  FutureOr<FlightPreviewModel> build(String id) {
    return fetchFlightPreview(id);
  }

  Future<FlightPreviewModel> fetchFlightPreview(String id) async {
    final asyncHander = ref.read(asyncRequestHandlerProvider.notifier);
    return await asyncHander.execute<FlightPreviewModel>(
          state: state,
          apiCall: () =>
              ref.read(flightDetailUserCaseProvider).getFlightPreview(id),
          onSuccess: (response) {
            state = AsyncValue.data(response);
          },
          cancelPrevious: true,
        ) ??
        FlightPreviewModel();
  }
}

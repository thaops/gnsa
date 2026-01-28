import 'package:gnsa/dio_api/providers/dio_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_preview_provider.g.dart';

@riverpod
class FlightPreviewProvider extends _$FlightPreviewProvider {
  @override
  FutureOr<FlightPreviewModel> build(PreviewArgs args) {
    return fetchFlightPreview(args);
  }

  Future<FlightPreviewModel> fetchFlightPreview(PreviewArgs args) async {
    final asyncHander = ref.read(asyncRequestHandlerProvider.notifier);
    return await asyncHander.execute<FlightPreviewModel>(
          state: state,
          apiCall: () =>
              ref.read(flightDetailUserCaseProvider).getFlightPreview(args),
          onSuccess: (response) {
            state = AsyncValue.data(response);
          },
          cancelPrevious: true,
        ) ??
        FlightPreviewModel();
  }
}

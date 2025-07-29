import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_qr_provider.g.dart';

@riverpod
class GetQrProvider extends _$GetQrProvider {
  @override
  FutureOr<String> build(String flightId) {
    return getQr(flightId);
  }

  Future<String> getQr(String flightId) async {
    final asyncHandler = ref.read(asyncRequestHandlerProvider.notifier);
    return await asyncHandler.execute<String>(
      state: state,
      apiCall: () => ref.read(flightDetailUserCaseProvider).getQr(flightId),
      onSuccess: (response) {
        state = AsyncValue.data(response);
      },
      cancelPrevious: true,
    ) ?? '';
  }
}
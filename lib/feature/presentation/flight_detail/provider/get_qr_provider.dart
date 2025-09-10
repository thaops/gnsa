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
    print("GetQrProvider.getQr called with flightId: $flightId");

    // Check if the provider is still mounted
    if (!ref.mounted) {
      print("GetQrProvider: Ref is not mounted, returning empty string");
      return '';
    }

    try {
      final asyncHandler = ref.read(asyncRequestHandlerProvider.notifier);
      final result = await asyncHandler.execute<String>(
        state: state,
        apiCall: () {
          // Check if the provider is still mounted before making the API call
          if (!ref.mounted) {
            print(
                "GetQrProvider: Ref is not mounted during API call, throwing exception");
            throw Exception("Provider disposed during API call");
          }
          return ref.read(flightDetailUserCaseProvider).getQr(flightId);
        },
        onSuccess: (response) {
          print("GetQrProvider.onSuccess called with response: '$response'");
          // Check if the provider is still mounted before updating state
          if (ref.mounted) {
            state = AsyncValue.data(response);
          } else {
            print(
                "GetQrProvider: Ref is not mounted during onSuccess, skipping state update");
          }
        },
        onError: (error, stackTrace) {
          print("GetQrProvider.onError called with error: $error");
          // Don't override the state here as asyncHandler will handle it
        },
        cancelPrevious: true,
      );

      return result ?? '';
    } catch (e) {
      print("GetQrProvider: Caught exception: $e");
      return '';
    }
  }
}

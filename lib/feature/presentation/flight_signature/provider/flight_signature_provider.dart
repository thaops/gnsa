import 'dart:async';

import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
import 'package:gnsa/feature/presentation/flight_signature/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_signature_provider.g.dart';

@riverpod
class FlightSignatureController extends _$FlightSignatureController {
  @override
  Future<SignSupplyfrom> build(String supplyfromId) async {
    return getSingSupplyfrom(supplyfromId);
  }

  Future<SignSupplyfrom> getSingSupplyfrom(String supplyfromId) async {
    final handleAsync = ref.read(asyncRequestHandlerProvider.notifier);
    await handleAsync.execute<SignSupplyfrom>(
      apiCall: () => ref
          .read(flightSignatureUserCaseProvider)
          .getSignSupplyfrom(supplyfromId),
      onSuccess: (data) {
        state = AsyncValue.data(data);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
    return state.value as SignSupplyfrom;
  }
}

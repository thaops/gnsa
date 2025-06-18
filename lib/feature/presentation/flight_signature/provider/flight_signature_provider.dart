import 'dart:async';

import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_signature/model/sign_supplyfrom.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_signature_provider.g.dart';

@riverpod
class FlightSignatureController extends _$FlightSignatureController {

  @override
  Future<SignSupplyfrom> build() async {
    return SignSupplyfrom();
  }

 Future<void> getSingSupplyfrom(String supplyfromId) async {
    try {
      state = const AsyncValue.loading();
      final dioApi = ref.read(dioApiProvider);
      final response = await dioApi.get(
        ApiEndpoints.getSignedSupplyForm(supplyFormId: supplyfromId)
      );
      final data = SignSupplyfrom.fromJson(response.data['Data']);
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

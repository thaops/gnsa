import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';

part 'supply_from_update_provider.g.dart';

@riverpod
class SupplyFromUpdateProvider extends _$SupplyFromUpdateProvider {
  @override
  FutureOr<void> build() {}
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req) async {
    final asyncHandler = ref.read(asyncRequestHandlerProvider.notifier);
    return await asyncHandler.execute<String>(
          apiCall: () => ref
              .read(flightDetailUserCaseProvider)
              .updateSupplyfromItemDetail(req),
          onSuccess: (response) {
            response;
          },
          cancelPrevious: true,
        ) ??
        '';
  }
}

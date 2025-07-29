import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_item_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_list_provider.g.dart';

@riverpod
class CardListProvider extends _$CardListProvider {
  @override
  Future<List<CardItemModel>> build() {
    return getListCart();
  }
  Future<List<CardItemModel>> getListCart() async {
    final asyncRequestHandler = ref.read(asyncRequestHandlerProvider.notifier);
    return await asyncRequestHandler.execute(
      state: state,
      apiCall: () => ref.read(flightDetailUserCaseProvider).getListCart(),
      onSuccess: (data) => state = AsyncValue.data(data),
      cancelPrevious: true,
    ) ?? [];
  }
}
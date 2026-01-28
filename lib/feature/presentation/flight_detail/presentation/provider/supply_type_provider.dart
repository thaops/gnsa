import 'package:gnsa/feature/presentation/flight_detail/data/model/supply_type_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supply_type_provider.g.dart';

@riverpod
Future<List<SupplyTypeModel>> supplyTypeProvider(Ref ref) async {
  final repo = ref.read(flightDetailUserCaseProvider);
  return repo.getSupplyTypes();
}

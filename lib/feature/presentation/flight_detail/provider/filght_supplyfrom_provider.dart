import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';

part 'filght_supplyfrom_provider.g.dart';

/// Quản lý cập nhật ghi chú vật tư
@riverpod
class FilghtSupplyfromProvider extends _$FilghtSupplyfromProvider {
  @override
  void build() {
    // Không cần trạng thái, chỉ cung cấp phương thức
  }

  /// Cập nhật ghi chú vật tư
  Future<void> updateSupplyNote({
    String? supplyFormId,
    String? supplyId,
    String? note,
    int? confirmedQuantity,
  }) async {
    final dioApi = ref.read(dioApiProvider);
    try {
      await dioApi.patch(
        ApiEndpoints.updateSupplyFormNote,
        data: {
          'SupplyFormId': supplyFormId,
          'SupplyId': supplyId,
          'ConfirmedQuantity': confirmedQuantity,
          'Note': note,
        },
      );
    } catch (e) {
      print('Error updating supply note: $e');
    }
  }
}
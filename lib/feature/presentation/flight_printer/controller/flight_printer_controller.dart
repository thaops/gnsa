import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/method_channel/printer_plugin.dart' show UrovoPrinter;
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';

class FlightPrinterController extends StateNotifier<FlightDetailModel?> {
  FlightPrinterController() : super(null);

  Future<void> printJson({
    required BuildContext context,
    required FlightDetailModel? flightDetail,
    required List<String> selectedItems,
  }) async {
    if (flightDetail == null) {
      await CustomFlushbar.showError(context, message: 'Lỗi khi in phiếu');
      return;
    }

    try {
      FlightDetailModel dataToPrint;

      // Nếu không chọn gì, thông báo lỗi
      if (selectedItems.isEmpty) {
        await CustomFlushbar.showError(context, message: 'Vui lòng chọn ít nhất một mục để in');
        return;
      }

      // Nếu chọn "All", in toàn bộ flightDetail
      if (selectedItems.contains("All")) {
        dataToPrint = flightDetail;
        print("Printing all data: ${dataToPrint.toJson()}");
      } else {
        // Lọc SupplyForm theo selectedItems (category)
        final filteredSupplyForms = flightDetail.supplyForms?.where((form) {
          return selectedItems.contains(form.category?.trim());
        }).toList();

        // Nếu không có SupplyForm nào khớp, thông báo lỗi
        if (filteredSupplyForms == null || filteredSupplyForms.isEmpty) {
          await CustomFlushbar.showError(context, message: 'Không có dữ liệu phù hợp để in');
          return;
        }

        // Tạo FlightDetailModel mới với dữ liệu đã lọc
        dataToPrint = FlightDetailModel(
          flight: flightDetail.flight, // Giữ nguyên flight
          supplyForms: filteredSupplyForms,
        );
        print("Printing filtered data: ${dataToPrint.toJson()}");
      }

      final result = await UrovoPrinter().printGnsa(dataToPrint);
      await CustomFlushbar.showSuccess(context, message: result ?? "In thành công");
      state = dataToPrint; // Cập nhật state với dữ liệu đã in
    } catch (e) {
      await CustomFlushbar.showError(context, message: 'Lỗi khi in phiếu: $e');
    }
  }
}

final flightPrinterBindingProvider =
    StateNotifierProvider<FlightPrinterController, FlightDetailModel?>(
  (ref) => FlightPrinterController(),
);
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/method_channel/printer_plugin.dart' show UrovoPrinter;
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';

// Constants
const _kAllOption = 'All';

class FlightPrinterController extends StateNotifier<FlightDetailModel?> {
  FlightPrinterController() : super(null);

  Future<void> printJson({
    required BuildContext context,
    required FlightDetailModel? flightDetail,
    required List<String> selectedItems,
  }) async {
    if (!_validateInput(context, flightDetail, selectedItems)) return;

    try {
      final dataToPrint = _preparePrintData(flightDetail!, selectedItems);
      await _printData(context, dataToPrint);
    } catch (e) {
      await _showError(context, 'Error printing: $e');
    }
  }

  bool _validateInput(
    BuildContext context,
    FlightDetailModel? flightDetail,
    List<String> selectedItems,
  ) {
    if (flightDetail == null) {
      _showError(context, 'Invalid flight data');
      return false;
    }
    if (selectedItems.isEmpty) {
      _showError(context, 'Please select at least one item to print');
      return false;
    }
    return true;
  }

  FlightDetailModel _preparePrintData(
    FlightDetailModel flightDetail,
    List<String> selectedItems,
  ) {
    if (selectedItems.contains(_kAllOption)) {
      print("Printing all data: ${flightDetail.toJson()}");
      return flightDetail;
    }

    final filteredSupplyForms = _filterSupplyForms(flightDetail, selectedItems);
    print("Printing filtered data: ${flightDetail.toJson()}");
    return FlightDetailModel(
      flight: flightDetail.flight,
      supplyForms: filteredSupplyForms,
    );
  }

  List<SupplyForm>? _filterSupplyForms(
    FlightDetailModel flightDetail,
    List<String> selectedItems,
  ) {
    return flightDetail.supplyForms?.where((form) {
      return selectedItems.contains(form.category?.trim());
    }).toList();
  }

  Future<void> _printData(BuildContext context, FlightDetailModel data) async {
    final result = await UrovoPrinter().printGnsa(data);
    await CustomFlushbar.showSuccess(context, message: result ?? "Print successful");
    state = data;
  }

  Future<void> _showError(BuildContext context, String message) async {
    await CustomFlushbar.showError(context, message: message);
  }
}

final flightPrinterBindingProvider =
    StateNotifierProvider<FlightPrinterController, FlightDetailModel?>(
  (ref) => FlightPrinterController(),
);
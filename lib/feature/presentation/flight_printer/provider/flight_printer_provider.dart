import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/method_channel/printer_plugin.dart' show UrovoPrinter;
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_printer_provider.g.dart';

// Constants
const _kAllOption = 'All';

@riverpod
class FlightPrinterController extends _$FlightPrinterController {
  @override
  SupplyFormModel? build() {
    return null;
  }

  Future<void> printJson({
    required BuildContext context,
    required SupplyFormModel? flightDetail,
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
    SupplyFormModel? flightDetail,
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

  SupplyFormModel _preparePrintData(
    SupplyFormModel flightDetail,
    List<String> selectedItems,
  ) {
    if (selectedItems.contains(_kAllOption)) {
      return flightDetail;
    }

    final filteredSupplyForms = _filterSupplyForms(flightDetail, selectedItems);
    return SupplyFormModel(
      flightInfo: flightDetail.flightInfo,
      supplyFormDetails: filteredSupplyForms,
    );
  }

  List<SupplyFormDetail>? _filterSupplyForms(
    SupplyFormModel flightDetail,
    List<String> selectedItems,
  ) {
    return flightDetail.supplyFormDetails?.where((form) {
      return selectedItems.contains(form.supplyType?.trim());
    }).toList();
  }

  Future<void> _printData(BuildContext context, SupplyFormModel data) async {
    final result = await UrovoPrinter().printGnsa(data);
    await CustomFlushbar.showSuccess(context, message: result ?? "Print successful");
    state = data;
  }

  Future<void> _showError(BuildContext context, String message) async {
    await CustomFlushbar.showError(context, message: message);
  }
}

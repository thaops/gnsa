import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightPrinterController extends StateNotifier<List<bool>> {
  FlightPrinterController() : super([]);

  void toggleChecked(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) !state[i] else state[i],
    ];
  }

  void addItem() {
    state = [...state, false];
  }
}

final flightPrinterProvider = StateNotifierProvider<FlightPrinterController, List<bool>>((ref) {
  return FlightPrinterController();
});

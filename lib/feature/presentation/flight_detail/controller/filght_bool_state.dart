import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightBoolState extends StateNotifier<bool> {
  FlightBoolState() : super(false);
  void toggleEdit() {
    state = !state;
  }
  void toggleExpansion() {
    state = !state;
  }
}

final isEditProvider = StateNotifierProvider<FlightBoolState, bool>((ref) {
  return FlightBoolState();
});

final isExpandedProvider = StateNotifierProvider<FlightBoolState, bool>((ref) {
  return FlightBoolState();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'filght_bool_provider.g.dart';

@riverpod
class FilghtBoolProvider extends _$FilghtBoolProvider {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

@riverpod
class IsEditProvider extends _$IsEditProvider {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

/// Provider cho trạng thái mở rộng
@riverpod
class IsExpandedProvider extends _$IsExpandedProvider {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

/// Provider cho trạng thái mở rộng con
@riverpod
class IsChildExpandedProvider extends _$IsChildExpandedProvider {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}
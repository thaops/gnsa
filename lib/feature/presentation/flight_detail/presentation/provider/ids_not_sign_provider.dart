// File: lib/providers/ids_not_sign_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ids_not_sign_provider.g.dart';

/// Provider for managing regular signing IDs
@riverpod
class IdsNotSign extends _$IdsNotSign {
  @override
  List<String> build() {
    return [];
  }
  
  /// Add a single ID to the list
  void addId(String id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }
  
  /// Add multiple IDs to the list
  void addIds(List<String> ids) {
    final newIds = ids.where((id) => !state.contains(id)).toList();
    if (newIds.isNotEmpty) {
      state = [...state, ...newIds];
    }
  }
  
  /// Remove a specific ID from the list
  void removeId(String id) {
    state = state.where((element) => element != id).toList();
  }
  
  /// Clear all IDs from the list
  void clearIds() {
    state = [];
  }
  
  /// Set the entire list (useful for initialization)
  void setIds(List<String> ids) {
    state = [...ids];
  }
}

/// Provider for managing additional signing IDs
@riverpod
class IdsNotSignAdditional extends _$IdsNotSignAdditional {
  @override
  List<String> build() {
    return [];
  }
  
  /// Add a single ID to the list
  void addId(String id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }
  
  /// Add multiple IDs to the list
  void addIds(List<String> ids) {
    final newIds = ids.where((id) => !state.contains(id)).toList();
    if (newIds.isNotEmpty) {
      state = [...state, ...newIds];
    }
  }
  
  /// Remove a specific ID from the list
  void removeId(String id) {
    state = state.where((element) => element != id).toList();
  }
  
  /// Clear all IDs from the list
  void clearIds() {
    state = [];
  }
  
  /// Set the entire list (useful for initialization)
  void setIds(List<String> ids) {
    state = [...ids];
  }
}

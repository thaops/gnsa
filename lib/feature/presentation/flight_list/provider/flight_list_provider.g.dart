// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Notifier quản lý danh sách chuyến bay với tìm kiếm và tải thêm
@ProviderFor(FlightListNotifier)
const flightListNotifierProvider = FlightListNotifierProvider._();

/// Notifier quản lý danh sách chuyến bay với tìm kiếm và tải thêm
final class FlightListNotifierProvider
    extends $AsyncNotifierProvider<FlightListNotifier, FlightsModel> {
  /// Notifier quản lý danh sách chuyến bay với tìm kiếm và tải thêm
  const FlightListNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'flightListNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightListNotifierHash();

  @$internal
  @override
  FlightListNotifier create() => FlightListNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightListNotifier, FlightsModel>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$flightListNotifierHash() =>
    r'd3b6666e6ff0b35bcbab3cde32eda81c163b25d0';

abstract class _$FlightListNotifier extends $AsyncNotifier<FlightsModel> {
  FutureOr<FlightsModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FlightsModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<FlightsModel>>,
        AsyncValue<FlightsModel>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

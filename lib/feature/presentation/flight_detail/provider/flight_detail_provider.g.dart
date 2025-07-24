// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightDetailProvider)
const flightDetailProviderProvider = FlightDetailProviderProvider._();

final class FlightDetailProviderProvider
    extends $AsyncNotifierProvider<FlightDetailProvider, SupplyFormModel> {
  const FlightDetailProviderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'flightDetailProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightDetailProviderHash();

  @$internal
  @override
  FlightDetailProvider create() => FlightDetailProvider();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightDetailProvider, SupplyFormModel>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$flightDetailProviderHash() =>
    r'287b29c2b7b73c59c1d221b21aa0348c91eb3208';

abstract class _$FlightDetailProvider extends $AsyncNotifier<SupplyFormModel> {
  FutureOr<SupplyFormModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SupplyFormModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<SupplyFormModel>>,
        AsyncValue<SupplyFormModel>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

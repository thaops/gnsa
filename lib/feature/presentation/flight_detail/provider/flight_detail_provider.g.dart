// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightDetailProvider)
const flightDetailProviderProvider = FlightDetailProviderProvider._();

final class FlightDetailProviderProvider
    extends $AsyncNotifierProvider<FlightDetailProvider, FlightDetailModel> {
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
  $AsyncNotifierProviderElement<FlightDetailProvider, FlightDetailModel>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$flightDetailProviderHash() =>
    r'17c4028480a0c8c23f919ebba10c82639ca5e7f5';

abstract class _$FlightDetailProvider
    extends $AsyncNotifier<FlightDetailModel> {
  FutureOr<FlightDetailModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FlightDetailModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<FlightDetailModel>>,
        AsyncValue<FlightDetailModel>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

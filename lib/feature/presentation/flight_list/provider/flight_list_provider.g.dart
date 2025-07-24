// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightListNotifier)
const flightListNotifierProvider = FlightListNotifierProvider._();

final class FlightListNotifierProvider
    extends $AsyncNotifierProvider<FlightListNotifier, FlightsModel> {
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
    r'423acadf99feaf45371c6fb4a2d354d9579f764f';

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

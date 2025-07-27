// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_sign_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightSignNotifier)
const flightSignNotifierProvider = FlightSignNotifierProvider._();

final class FlightSignNotifierProvider
    extends $AsyncNotifierProvider<FlightSignNotifier, bool?> {
  const FlightSignNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'flightSignNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightSignNotifierHash();

  @$internal
  @override
  FlightSignNotifier create() => FlightSignNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightSignNotifier, bool?> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$flightSignNotifierHash() =>
    r'3da9775ab1793db7382dff2edf9a4c8d26066f03';

abstract class _$FlightSignNotifier extends $AsyncNotifier<bool?> {
  FutureOr<bool?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<bool?>>, AsyncValue<bool?>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

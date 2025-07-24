// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_signature_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightSignatureController)
const flightSignatureControllerProvider = FlightSignatureControllerProvider._();

final class FlightSignatureControllerProvider
    extends $AsyncNotifierProvider<FlightSignatureController, SignSupplyfrom> {
  const FlightSignatureControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'flightSignatureControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightSignatureControllerHash();

  @$internal
  @override
  FlightSignatureController create() => FlightSignatureController();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightSignatureController, SignSupplyfrom>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$flightSignatureControllerHash() =>
    r'f5740e4812433444ad29f12a995be18f82b266fe';

abstract class _$FlightSignatureController
    extends $AsyncNotifier<SignSupplyfrom> {
  FutureOr<SignSupplyfrom> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SignSupplyfrom>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<SignSupplyfrom>>,
        AsyncValue<SignSupplyfrom>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

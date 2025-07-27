// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_signature_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightSignatureController)
const flightSignatureControllerProvider = FlightSignatureControllerFamily._();

final class FlightSignatureControllerProvider
    extends $AsyncNotifierProvider<FlightSignatureController, SignSupplyfrom> {
  const FlightSignatureControllerProvider._(
      {required FlightSignatureControllerFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'flightSignatureControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightSignatureControllerHash();

  @override
  String toString() {
    return r'flightSignatureControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FlightSignatureController create() => FlightSignatureController();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightSignatureController, SignSupplyfrom>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is FlightSignatureControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$flightSignatureControllerHash() =>
    r'4feae43e194e1c44e2827c2656c3ddc6a4be54c0';

final class FlightSignatureControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            FlightSignatureController,
            AsyncValue<SignSupplyfrom>,
            SignSupplyfrom,
            FutureOr<SignSupplyfrom>,
            String> {
  const FlightSignatureControllerFamily._()
      : super(
          retry: null,
          name: r'flightSignatureControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FlightSignatureControllerProvider call(
    String supplyfromId,
  ) =>
      FlightSignatureControllerProvider._(argument: supplyfromId, from: this);

  @override
  String toString() => r'flightSignatureControllerProvider';
}

abstract class _$FlightSignatureController
    extends $AsyncNotifier<SignSupplyfrom> {
  late final _$args = ref.$arg as String;
  String get supplyfromId => _$args;

  FutureOr<SignSupplyfrom> build(
    String supplyfromId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
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

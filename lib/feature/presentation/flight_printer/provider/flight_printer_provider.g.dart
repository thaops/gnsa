// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_printer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightPrinterController)
const flightPrinterControllerProvider = FlightPrinterControllerProvider._();

final class FlightPrinterControllerProvider
    extends $NotifierProvider<FlightPrinterController, SupplyFormModel?> {
  const FlightPrinterControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'flightPrinterControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightPrinterControllerHash();

  @$internal
  @override
  FlightPrinterController create() => FlightPrinterController();

  @$internal
  @override
  $NotifierProviderElement<FlightPrinterController, SupplyFormModel?>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupplyFormModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<SupplyFormModel?>(value),
    );
  }
}

String _$flightPrinterControllerHash() =>
    r'8b2f7ffcfa3ab3591e348341946b9d7a373f8a4d';

abstract class _$FlightPrinterController extends $Notifier<SupplyFormModel?> {
  SupplyFormModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SupplyFormModel?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SupplyFormModel?>, SupplyFormModel?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

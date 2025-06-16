// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_printer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightPrinterController)
const flightPrinterControllerProvider = FlightPrinterControllerProvider._();

final class FlightPrinterControllerProvider
    extends $NotifierProvider<FlightPrinterController, FlightDetailModel?> {
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
  $NotifierProviderElement<FlightPrinterController, FlightDetailModel?>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlightDetailModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<FlightDetailModel?>(value),
    );
  }
}

String _$flightPrinterControllerHash() =>
    r'97361dd7e90a2a1622ca448d02e3e7631d48a449';

abstract class _$FlightPrinterController extends $Notifier<FlightDetailModel?> {
  FlightDetailModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FlightDetailModel?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FlightDetailModel?>, FlightDetailModel?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

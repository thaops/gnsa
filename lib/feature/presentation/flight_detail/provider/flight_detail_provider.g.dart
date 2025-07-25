// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightDetailProvider)
const flightDetailProviderProvider = FlightDetailProviderFamily._();

final class FlightDetailProviderProvider
    extends $AsyncNotifierProvider<FlightDetailProvider, SupplyFormModel> {
  const FlightDetailProviderProvider._(
      {required FlightDetailProviderFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'flightDetailProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightDetailProviderHash();

  @override
  String toString() {
    return r'flightDetailProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FlightDetailProvider create() => FlightDetailProvider();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightDetailProvider, SupplyFormModel>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is FlightDetailProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$flightDetailProviderHash() =>
    r'bfac4a0115c4c07b01f64acbb27235ad41fe98a5';

final class FlightDetailProviderFamily extends $Family
    with
        $ClassFamilyOverride<FlightDetailProvider, AsyncValue<SupplyFormModel>,
            SupplyFormModel, FutureOr<SupplyFormModel>, String> {
  const FlightDetailProviderFamily._()
      : super(
          retry: null,
          name: r'flightDetailProviderProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FlightDetailProviderProvider call(
    String id,
  ) =>
      FlightDetailProviderProvider._(argument: id, from: this);

  @override
  String toString() => r'flightDetailProviderProvider';
}

abstract class _$FlightDetailProvider extends $AsyncNotifier<SupplyFormModel> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<SupplyFormModel> build(
    String id,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
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

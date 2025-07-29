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
      required (
        String, {
        bool isSkipLoading,
      })
          super.argument})
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
        '$argument';
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
    r'1a76ac08c2485edef292125027ee2b6ffb96683c';

final class FlightDetailProviderFamily extends $Family
    with
        $ClassFamilyOverride<
            FlightDetailProvider,
            AsyncValue<SupplyFormModel>,
            SupplyFormModel,
            FutureOr<SupplyFormModel>,
            (
              String, {
              bool isSkipLoading,
            })> {
  const FlightDetailProviderFamily._()
      : super(
          retry: null,
          name: r'flightDetailProviderProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FlightDetailProviderProvider call(
    String id, {
    bool isSkipLoading = false,
  }) =>
      FlightDetailProviderProvider._(argument: (
        id,
        isSkipLoading: isSkipLoading,
      ), from: this);

  @override
  String toString() => r'flightDetailProviderProvider';
}

abstract class _$FlightDetailProvider extends $AsyncNotifier<SupplyFormModel> {
  late final _$args = ref.$arg as (
    String, {
    bool isSkipLoading,
  });
  String get id => _$args.$1;
  bool get isSkipLoading => _$args.isSkipLoading;

  FutureOr<SupplyFormModel> build(
    String id, {
    bool isSkipLoading = false,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      isSkipLoading: _$args.isSkipLoading,
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

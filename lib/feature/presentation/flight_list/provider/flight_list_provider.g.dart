// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightListNotifier)
const flightListNotifierProvider = FlightListNotifierFamily._();

final class FlightListNotifierProvider
    extends $AsyncNotifierProvider<FlightListNotifier, FlightsModel> {
  const FlightListNotifierProvider._(
      {required FlightListNotifierFamily super.from,
      required bool super.argument})
      : super(
          retry: null,
          name: r'flightListNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightListNotifierHash();

  @override
  String toString() {
    return r'flightListNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FlightListNotifier create() => FlightListNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightListNotifier, FlightsModel>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is FlightListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$flightListNotifierHash() =>
    r'c3c4b389fe1d627dd719539c620c1809b40cdd9a';

final class FlightListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<FlightListNotifier, AsyncValue<FlightsModel>,
            FlightsModel, FutureOr<FlightsModel>, bool> {
  const FlightListNotifierFamily._()
      : super(
          retry: null,
          name: r'flightListNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  FlightListNotifierProvider call(
    bool isMyFlight,
  ) =>
      FlightListNotifierProvider._(argument: isMyFlight, from: this);

  @override
  String toString() => r'flightListNotifierProvider';
}

abstract class _$FlightListNotifier extends $AsyncNotifier<FlightsModel> {
  late final _$args = ref.$arg as bool;
  bool get isMyFlight => _$args;

  FutureOr<FlightsModel> build(
    bool isMyFlight,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
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

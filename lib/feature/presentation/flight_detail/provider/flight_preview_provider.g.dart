// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FlightPreviewProvider)
const flightPreviewProviderProvider = FlightPreviewProviderFamily._();

final class FlightPreviewProviderProvider
    extends $AsyncNotifierProvider<FlightPreviewProvider, FlightPreviewModel> {
  const FlightPreviewProviderProvider._(
      {required FlightPreviewProviderFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'flightPreviewProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$flightPreviewProviderHash();

  @override
  String toString() {
    return r'flightPreviewProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FlightPreviewProvider create() => FlightPreviewProvider();

  @$internal
  @override
  $AsyncNotifierProviderElement<FlightPreviewProvider, FlightPreviewModel>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is FlightPreviewProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$flightPreviewProviderHash() =>
    r'c2ae1c2832f58123919f4b72352950b405eba9c6';

final class FlightPreviewProviderFamily extends $Family
    with
        $ClassFamilyOverride<
            FlightPreviewProvider,
            AsyncValue<FlightPreviewModel>,
            FlightPreviewModel,
            FutureOr<FlightPreviewModel>,
            String> {
  const FlightPreviewProviderFamily._()
      : super(
          retry: null,
          name: r'flightPreviewProviderProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FlightPreviewProviderProvider call(
    String id,
  ) =>
      FlightPreviewProviderProvider._(argument: id, from: this);

  @override
  String toString() => r'flightPreviewProviderProvider';
}

abstract class _$FlightPreviewProvider
    extends $AsyncNotifier<FlightPreviewModel> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<FlightPreviewModel> build(
    String id,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<FlightPreviewModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<FlightPreviewModel>>,
        AsyncValue<FlightPreviewModel>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

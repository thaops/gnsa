// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_qr_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(GetQrProvider)
const getQrProviderProvider = GetQrProviderFamily._();

final class GetQrProviderProvider
    extends $AsyncNotifierProvider<GetQrProvider, String> {
  const GetQrProviderProvider._(
      {required GetQrProviderFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'getQrProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getQrProviderHash();

  @override
  String toString() {
    return r'getQrProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GetQrProvider create() => GetQrProvider();

  @$internal
  @override
  $AsyncNotifierProviderElement<GetQrProvider, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is GetQrProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getQrProviderHash() => r'a39481d36c6dd3857c3f5b91b0c7a7d078a1c73a';

final class GetQrProviderFamily extends $Family
    with
        $ClassFamilyOverride<GetQrProvider, AsyncValue<String>, String,
            FutureOr<String>, String> {
  const GetQrProviderFamily._()
      : super(
          retry: null,
          name: r'getQrProviderProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GetQrProviderProvider call(
    String flightId,
  ) =>
      GetQrProviderProvider._(argument: flightId, from: this);

  @override
  String toString() => r'getQrProviderProvider';
}

abstract class _$GetQrProvider extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as String;
  String get flightId => _$args;

  FutureOr<String> build(
    String flightId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>>, AsyncValue<String>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

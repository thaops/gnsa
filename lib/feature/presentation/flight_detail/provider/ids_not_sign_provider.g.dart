// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ids_not_sign_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for managing regular signing IDs
@ProviderFor(IdsNotSign)
const idsNotSignProvider = IdsNotSignProvider._();

/// Provider for managing regular signing IDs
final class IdsNotSignProvider
    extends $NotifierProvider<IdsNotSign, List<String>> {
  /// Provider for managing regular signing IDs
  const IdsNotSignProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'idsNotSignProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$idsNotSignHash();

  @$internal
  @override
  IdsNotSign create() => IdsNotSign();

  @$internal
  @override
  $NotifierProviderElement<IdsNotSign, List<String>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<String>>(value),
    );
  }
}

String _$idsNotSignHash() => r'7d1da04ef830c66933597c0891b590d78b3bea24';

abstract class _$IdsNotSign extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<String>>, List<String>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider for managing additional signing IDs
@ProviderFor(IdsNotSignAdditional)
const idsNotSignAdditionalProvider = IdsNotSignAdditionalProvider._();

/// Provider for managing additional signing IDs
final class IdsNotSignAdditionalProvider
    extends $NotifierProvider<IdsNotSignAdditional, List<String>> {
  /// Provider for managing additional signing IDs
  const IdsNotSignAdditionalProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'idsNotSignAdditionalProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$idsNotSignAdditionalHash();

  @$internal
  @override
  IdsNotSignAdditional create() => IdsNotSignAdditional();

  @$internal
  @override
  $NotifierProviderElement<IdsNotSignAdditional, List<String>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<String>>(value),
    );
  }
}

String _$idsNotSignAdditionalHash() =>
    r'4a0220fad6c2b83abbdfabbd0ac82b8156828412';

abstract class _$IdsNotSignAdditional extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<String>>, List<String>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

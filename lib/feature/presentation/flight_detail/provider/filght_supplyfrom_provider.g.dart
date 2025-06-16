// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filght_supplyfrom_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Quản lý cập nhật ghi chú vật tư
@ProviderFor(FilghtSupplyfromProvider)
const filghtSupplyfromProviderProvider = FilghtSupplyfromProviderProvider._();

/// Quản lý cập nhật ghi chú vật tư
final class FilghtSupplyfromProviderProvider
    extends $NotifierProvider<FilghtSupplyfromProvider, void> {
  /// Quản lý cập nhật ghi chú vật tư
  const FilghtSupplyfromProviderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filghtSupplyfromProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filghtSupplyfromProviderHash();

  @$internal
  @override
  FilghtSupplyfromProvider create() => FilghtSupplyfromProvider();

  @$internal
  @override
  $NotifierProviderElement<FilghtSupplyfromProvider, void> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }
}

String _$filghtSupplyfromProviderHash() =>
    r'8385e0ae457c84fa3139e47951f21524559a56ca';

abstract class _$FilghtSupplyfromProvider extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_from_update_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SupplyFromUpdateProvider)
const supplyFromUpdateProviderProvider = SupplyFromUpdateProviderProvider._();

final class SupplyFromUpdateProviderProvider
    extends $AsyncNotifierProvider<SupplyFromUpdateProvider, void> {
  const SupplyFromUpdateProviderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'supplyFromUpdateProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$supplyFromUpdateProviderHash();

  @$internal
  @override
  SupplyFromUpdateProvider create() => SupplyFromUpdateProvider();

  @$internal
  @override
  $AsyncNotifierProviderElement<SupplyFromUpdateProvider, void> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$supplyFromUpdateProviderHash() =>
    r'd77c2f43589c260268c39a329e1742f93ef76646';

abstract class _$SupplyFromUpdateProvider extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>>, AsyncValue<void>, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

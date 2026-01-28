// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_type_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(supplyTypeProvider)
const supplyTypeProviderProvider = SupplyTypeProviderProvider._();

final class SupplyTypeProviderProvider extends $FunctionalProvider<
        AsyncValue<List<SupplyTypeModel>>, FutureOr<List<SupplyTypeModel>>>
    with
        $FutureModifier<List<SupplyTypeModel>>,
        $FutureProvider<List<SupplyTypeModel>> {
  const SupplyTypeProviderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'supplyTypeProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$supplyTypeProviderHash();

  @$internal
  @override
  $FutureProviderElement<List<SupplyTypeModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SupplyTypeModel>> create(Ref ref) {
    return supplyTypeProvider(ref);
  }
}

String _$supplyTypeProviderHash() =>
    r'b6e8f22f6229b50cec231bed4ea52a25350a6bd2';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

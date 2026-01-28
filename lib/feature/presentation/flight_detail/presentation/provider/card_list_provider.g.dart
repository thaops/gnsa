// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CardListProvider)
const cardListProviderProvider = CardListProviderProvider._();

final class CardListProviderProvider
    extends $AsyncNotifierProvider<CardListProvider, List<CardItemModel>> {
  const CardListProviderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cardListProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cardListProviderHash();

  @$internal
  @override
  CardListProvider create() => CardListProvider();

  @$internal
  @override
  $AsyncNotifierProviderElement<CardListProvider, List<CardItemModel>>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$cardListProviderHash() => r'23e1fcd647b4f9294ce1ee7efe46dc06d331581a';

abstract class _$CardListProvider extends $AsyncNotifier<List<CardItemModel>> {
  FutureOr<List<CardItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<CardItemModel>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<CardItemModel>>>,
        AsyncValue<List<CardItemModel>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

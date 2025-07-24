// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(LoginController)
const loginControllerProvider = LoginControllerProvider._();

final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, LoginState> {
  const LoginControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();

  @$internal
  @override
  $AsyncNotifierProviderElement<LoginController, LoginState> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$loginControllerHash() => r'e378f21456062cd78cab07cf51bf0c8a422a996f';

abstract class _$LoginController extends $AsyncNotifier<LoginState> {
  FutureOr<LoginState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<LoginState>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<LoginState>>,
        AsyncValue<LoginState>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

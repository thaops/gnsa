import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/Services/services_base/api_service_ref.dart';
import 'package:gnsa/feature/auth/data/datasources/login_remote_data_sources.dart';
import 'package:gnsa/feature/auth/data/repositories/login_repository_impl.dart';
import 'package:gnsa/feature/auth/domain/repositories/login_repository.dart';

final servicesProvider = Provider<Services>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  
  return sharedPreferences.when(
    data: (prefs) => Services(prefs),
    loading: () {
      throw Exception('SharedPreferences is still loading');
    },
    error: (error, stack) {
      throw Exception('Failed to load SharedPreferences: $error');
    },
  );
});
final loginRemoteDataSourceProvider = Provider<LoginRemoteDataSources>((ref) {
  return LoginRemoteDataSourcesImpl(ref.read(dioApiProvider));
});

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepositoryImpl(ref.read(loginRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(loginRepositoryProvider));
});
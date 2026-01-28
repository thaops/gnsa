import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/dio_api/providers/dio_provider.dart';
import 'package:gnsa/feature/auth/data/datasources/login_remote_data_sources.dart';
import 'package:gnsa/feature/auth/data/repositories/login_repository_impl.dart';
import 'package:gnsa/feature/auth/domain/repositories/login_repository.dart';

final loginRemoteDataSourceProvider = Provider<LoginRemoteDataSources>((ref) {
  return LoginRemoteDataSourcesImpl(ref.read(dioApiProvider));
});

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepositoryImpl(ref.read(loginRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(loginRepositoryProvider));
});

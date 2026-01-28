import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AsyncRequestHandler extends StateNotifier<void> {
  AsyncRequestHandler() : super(null);

  Future<T?> execute<T>({
    AsyncValue<dynamic>? state,
    required Future<T> Function() apiCall,
    Function(T)? onSuccess,
    Function(Object, StackTrace)? onError,
    bool rethrowError = false,
    bool cancelPrevious = false,
    bool isSkipLoading = false,
  }) async {
    try {
      final result = await apiCall();
      onSuccess?.call(result);
      return result;
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      if (rethrowError) rethrow;
      return null;
    }
  }
}

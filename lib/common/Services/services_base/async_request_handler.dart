import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef ApiCall<T> = Future<T> Function();
typedef OnSuccess<T> = FutureOr<void> Function(T response);
typedef OnError = FutureOr<void> Function(Object error, StackTrace stackTrace);

class AsyncRequestHandler extends StateNotifier<AsyncValue<void>> {
  AsyncRequestHandler() : super(const AsyncValue.data(null));

  Future<T> execute<T>({
    required ApiCall<T> apiCall,
    required OnSuccess<T> onSuccess,
    OnError? onError,
    bool rethrowError = true,
    bool cancelPrevious = true,
  }) async {

    if (cancelPrevious && state.isLoading) {
      state = const AsyncValue.data(null);
    }


    state = const AsyncValue.loading();
    
    try {
      final response = await apiCall();
      if(!mounted) return response;
      await onSuccess(response);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      if(rethrowError){
        rethrow;
      }
      await onError?.call(e, st);
      if(mounted){
        state = AsyncValue.error(e, st);
      }

      return Future.value() as T;
     
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
}

final asyncRequestHandlerProvider = 
  StateNotifierProvider<AsyncRequestHandler, AsyncValue<void>>(
    (ref) {
      final handler = AsyncRequestHandler();
      ref.onDispose(() {
        handler.dispose();
      });
      return handler;
    },
  );
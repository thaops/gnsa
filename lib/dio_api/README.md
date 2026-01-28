# DioApi Module

## Cấu trúc

```
dio_api/
├── dio_api.dart              # DioApi class (backward compatible)
├── network/
│   └── dio_client.dart       # DioClient với interceptors
├── providers/
│   └── dio_provider.dart     # Riverpod providers (thủ công)
└── utils/
    ├── device_service.dart   # Device info management
    └── device_udid.dart      # Device UDID utilities
```

## Providers

```dart
// Core providers
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(...);
final servicesProvider = FutureProvider<Services>(...);
final deviceServiceProvider = Provider<DeviceService>(...);

// Dio providers
final dioApiProvider = Provider<DioApi>(...);
final dioClientProvider = Provider<DioClient>(...);

// Helper providers
final asyncRequestHandlerProvider = StateNotifierProvider<AsyncRequestHandler, void>(...);
```

## Import Paths

```dart
// Providers (tất cả từ một file)
import 'package:gnsa/dio_api/providers/dio_provider.dart';

// Core services (nếu cần)
import 'package:gnsa/core/config/config.dart';
import 'package:gnsa/core/services/services.dart';
```

## Sử dụng

### AsyncRequestHandler (recommended)

```dart
final handler = ref.read(asyncRequestHandlerProvider.notifier);

await handler.execute<T>(
  state: state,
  apiCall: () => yourApiCall(),
  onSuccess: (data) => state = AsyncValue.data(data),
  onError: (error, stack) => print(error),
  cancelPrevious: true,
  isSkipLoading: false,
);
```

### DioApi (legacy - vẫn dùng được)

```dart
final dioApi = ref.watch(dioApiProvider);
await dioApi.get('/endpoint');
await dioApi.post('/endpoint', data: {...});
```

### DioClient (mới - lightweight)

```dart
final dioClient = ref.watch(dioClientProvider);
await dioClient.dio.get('/endpoint');
```

## AsyncRequestHandler Parameters

- `state`: AsyncValue state hiện tại
- `apiCall`: Function thực hiện API call
- `onSuccess`: Callback khi thành công
- `onError`: Callback khi lỗi
- `rethrowError`: Throw lại error (default: false)
- `cancelPrevious`: Cancel request trước đó (default: false)
- `isSkipLoading`: Skip loading state (default: false)

## Migration Guide

**Từ code cũ:**
```dart
import 'package:gnsa/common/Services/services_base/api_service_ref.dart';
final dioApi = ref.read(dioApiProvider);
```

**Sang code mới:**
```dart
import 'package:gnsa/dio_api/providers/dio_provider.dart';
final dioApi = ref.read(dioApiProvider);
```

Tất cả providers giờ từ một nơi duy nhất: `dio_provider.dart`

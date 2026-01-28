# Project Structure

## Core Modules

### `/lib/core`
Core business logic và shared services.

```
core/
├── config/
│   └── config.dart          # App configuration (baseUrl, etc)
└── services/
    └── services.dart        # SharedPreferences wrapper
```

### `/lib/dio_api`
Dio HTTP client và network layer.

```
dio_api/
├── dio_api.dart             # DioApi class (legacy, vẫn dùng được)
├── network/
│   └── dio_client.dart      # DioClient mới (đơn giản hơn)
├── providers/
│   └── dio_provider.dart    # Riverpod providers
└── utils/
    ├── device_service.dart  # Device info utilities
    └── device_udid.dart     # Device UDID management
```

### `/lib/common`
Shared UI components và utilities.

```
common/
├── Services/
│   ├── api_endpoints.dart   # API endpoints constants
│   └── auth_services.dart   # Auth-related services
├── constants/               # App constants
├── utils/                   # Utility functions
└── widgets/                 # Reusable widgets
```

## Module Organization

**Core (core/)**: Configuration, services cốt lõi
**DioApi (dio_api/)**: HTTP client, device info
**Common (common/)**: UI components, utilities, constants
**Features (feature/)**: Feature modules theo Clean Architecture

## Best Practices

1. Import từ core cho config/services:
```dart
import 'package:gnsa/core/config/config.dart';
import 'package:gnsa/core/services/services.dart';
```

2. Import từ dio_api cho network:
```dart
import 'package:gnsa/dio_api/providers/dio_provider.dart';
```

3. Providers viết thủ công, không dùng code generation:
```dart
final dioApiProvider = Provider<DioApi>((ref) => DioApi());
```

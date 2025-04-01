# Quy tắc mặc định từ Android (có thể có trong file mẫu)
-dontwarn okio.**
-dontwarn javax.annotation.**

# Giữ lại class android.device.PrinterManager và tất cả các thành viên của nó
-keep class android.device.PrinterManager { *; }

# Giữ lại tất cả các class trong package com.vacs.gnsa và các sub-package
-keep class com.vacs.gnsa.** { *; }
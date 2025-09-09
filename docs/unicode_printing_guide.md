# Unicode Printing Guide for Vietnamese Text

This guide explains how to use the improved Unicode printing functionality for Vietnamese text on Urovo POS devices.

## Overview

The new implementation addresses these issues:
1. Vietnamese text with diacritics now displays correctly
2. Text is clearer and more readable
3. Supports bold text, centering, and column layouts
4. Uses bitmap rendering for better font support

## How It Works

The solution renders text to a bitmap using Unicode fonts before sending it to the printer:

1. Text is drawn on a canvas with a Unicode font (Roboto)
2. The canvas is converted to a bitmap
3. The bitmap is sent to the printer using `drawBitmap()`

## Usage

### In Android (Kotlin)

The new methods are available in `MainActivity.kt`:

```kotlin
// Print a single line of Unicode text
printUnicodeTextLine("Cộng hòa xã hội chủ nghĩa Việt Nam", yPosition, 24f, true, true)

// Print a row with two columns
printUnicodeTextRow("Tên hàng", "Số lượng", yPosition, 20f, true)

// Print a sample text
printUnicodeTextSample("Your Vietnamese text here")
```

### In Flutter (Dart)

Use the `UrovoPrinter` class:

```dart
final printer = UrovoPrinter();

// Print Unicode text
await printer.printUnicodeText("Cộng hòa xã hội chủ nghĩa Việt Nam\nĐộc lập - Tự do - Hạnh phúc");

// Print a sample receipt
String receipt = '''Vietnam Airlines Caterers
Tan Son Nhat International Airport
Ho Chi Minh City, Vietnam

Flight: VN123                  PK: A321
Flight No: VN123               A/C: VN-A321

Name                           Qty
--------------------------------
Bánh mì thịt nguội             20
Nước suối                      30
''';

await printer.printUnicodeText(receipt);
```

## Font Support

The implementation tries to use Roboto font for better Unicode support:

1. Place `Roboto-Regular.ttf` in `android/app/src/main/assets/fonts/`
2. If the font file is not found, it falls back to system fonts

## Testing

A test widget is available at `lib/common/widgets/unicode_print_test.dart` that demonstrates:
1. Printing simple Vietnamese text
2. Printing a formatted receipt with proper layout

To use it, navigate to the UnicodePrintTest widget in your app.

## Benefits

1. **Clear Text**: Text is rendered at high resolution before printing
2. **Proper Vietnamese Support**: Diacritics display correctly
3. **Layout Control**: Supports bold, centering, and column layouts
4. **Fallback Support**: Falls back to system fonts if custom fonts are missing

## Troubleshooting

If you encounter issues:

1. Ensure the printer is properly connected and initialized
2. Check that the font files are in the correct location
3. Verify that the device has enough memory for bitmap operations
4. Make sure the text doesn't exceed the page width

## Limitations

1. Bitmap rendering uses more memory than direct text printing
2. Very long texts may need to be split into multiple pages
3. Font size adjustments may require tweaking the layout calculations
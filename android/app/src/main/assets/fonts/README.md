# Font Assets

This directory should contain Unicode fonts that support Vietnamese characters.

## Required Fonts:

1. Roboto-Regular.ttf - For regular text
2. Roboto-Bold.ttf - For bold text

## How to obtain these fonts:

1. Download from Google Fonts:
   - Roboto-Regular.ttf: https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Regular.ttf
   - Roboto-Bold.ttf: https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Bold.ttf

2. Or use Android's system fonts by modifying the code to use:
   - Typeface.create("sans-serif", Typeface.NORMAL)
   - Typeface.create("sans-serif", Typeface.BOLD)

The current implementation will fall back to system fonts if these files are not present.
@echo off
echo ===================================
echo Building optimized APK for Banking App
echo ===================================

echo.
echo Step 1: Cleaning the project...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Building release APK...
call flutter build apk --release --obfuscate --split-debug-info=build/debug-info

echo.
echo APK build complete!
echo Your APK is located at: build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can install it using:
echo adb install -r build\app\outputs\flutter-apk\app-release.apk
echo.
pause 
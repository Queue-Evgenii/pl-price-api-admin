#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"

export ANDROID_SDK_ROOT="$SDK_ROOT"
export ANDROID_HOME="$SDK_ROOT"

if ! java -version >/dev/null 2>&1; then
    CANDIDATE_JAVA_HOMES=(
        "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
        "/Applications/Android Studio.app/Contents/jre/Contents/Home"
        "$HOME/Applications/Android Studio.app/Contents/jbr/Contents/Home"
        "$HOME/Applications/Android Studio.app/Contents/jre/Contents/Home"
        "/Applications/Android Studio Preview.app/Contents/jbr/Contents/Home"
    )

    for CANDIDATE in "${CANDIDATE_JAVA_HOMES[@]}"; do
        if [ -x "$CANDIDATE/bin/java" ]; then
            export JAVA_HOME="$CANDIDATE"
            export PATH="$JAVA_HOME/bin:$PATH"
            break
        fi
    done
fi

if ! java -version >/dev/null 2>&1 && command -v /usr/libexec/java_home >/dev/null 2>&1; then
    JAVA_HOME_FROM_SYSTEM="$(/usr/libexec/java_home 2>/dev/null || true)"
    if [ -n "$JAVA_HOME_FROM_SYSTEM" ] && [ -x "$JAVA_HOME_FROM_SYSTEM/bin/java" ]; then
        export JAVA_HOME="$JAVA_HOME_FROM_SYSTEM"
        export PATH="$JAVA_HOME/bin:$PATH"
    fi
fi

if ! java -version >/dev/null 2>&1; then
    echo "Java (JDK) не найден. Установите JDK или Android Studio (встроенный JBR)."
    exit 1
fi

echo "🔨 Building frontend assets..."
cd "$ROOT_DIR"
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Frontend build failed!"
    exit 1
fi

echo "📦 Syncing Capacitor with Android..."
npx cap sync android

if [ $? -ne 0 ]; then
    echo "❌ Capacitor sync failed!"
    exit 1
fi

echo "🏗️ Building debug APK..."
cd "$ROOT_DIR/android"
if [ ! -f "$ROOT_DIR/android/local.properties" ]; then
    echo "sdk.dir=$SDK_ROOT" > "$ROOT_DIR/android/local.properties"
fi
rm -f "$ROOT_DIR"/android/app/build/outputs/apk/debug/pl-price-*.apk
EXPECTED_TS="$(date +'%y%m%d-%H%M')"
echo "Expected APK name pattern: pl-price-<version>-${EXPECTED_TS}.apk"
./gradlew assembleDebug

if [ $? -ne 0 ]; then
    echo "❌ APK build failed!"
    exit 1
fi

APK_FILE="$(ls -t "$ROOT_DIR"/android/app/build/outputs/apk/debug/*.apk | head -n 1)"
if [ -z "${APK_FILE:-}" ]; then
    echo "❌ Could not find debug APK after build."
    exit 1
fi

echo ""
echo "✅ APK build completed successfully!"
echo "📱 APK location: $(basename "$APK_FILE")"
echo "📁 Full path: $APK_FILE"
echo ""

if command -v adb >/dev/null 2>&1 && adb devices | awk 'NR>1 {print $2}' | grep -q '^device$'; then
    echo "📲 Android device detected. You can install with:"
    echo "   adb install \"$APK_FILE\""
    echo ""
    echo "🚀 Or run to install and launch:"
    echo "   ./run-apk.sh"
else
    echo "📋 To install manually:"
    echo "   1. Enable Developer Options on your Android device"
    echo "   2. Enable USB Debugging"
    echo "   3. Transfer APK to phone and install"
    echo "   4. Or use ADB when device is connected:"
    echo "      adb install \"$APK_FILE\""
fi

echo ""
echo "💡 For automatic deployment to emulator/device, use:"
echo "   npm run android:deploy"

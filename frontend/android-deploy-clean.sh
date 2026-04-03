#!/bin/bash

# Android deployment with full emulator restart
# Use this when changes don't appear due to caching

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
ADB="$SDK_ROOT/platform-tools/adb"
EMULATOR_BIN="$SDK_ROOT/emulator/emulator"
AVD_NAME="${1:-Medium_Phone_API_36.1}"

echo "🔄 Full Android deployment with emulator restart..."

# Setup version (bump patch + sync)
./version-setup.sh bump

# Build APK using common build script
source ./build-common.sh

# Check if any devices are connected
if ! "$ADB" devices | awk 'NR>1 {print $2}' | grep -q '^device$'; then
    echo "📱 No devices found. Starting emulator: $AVD_NAME"
    "$EMULATOR_BIN" -avd "$AVD_NAME" -no-audio > /dev/null 2>&1 &
    
    echo "⏳ Waiting for emulator to start..."
    "$ADB" wait-for-device
    until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
        sleep 2
    done
    echo "✅ Emulator is ready!"
else
    echo "📱 Device found. Proceeding with deployment..."
fi

# Install and launch app
echo "📦 Installing app..."
"$ADB" install -r "$APK_FILE"

APP_ID="com.priceapi.admin.debug"
echo "🚀 Launching application: $APP_ID"
"$ADB" shell monkey -p "$APP_ID" -c android.intent.category.LAUNCHER 1 >/dev/null

echo "🎉 Deployment completed! App is now running on the device/emulator."

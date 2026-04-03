#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

# Setup version (bump patch + sync)
./version-setup.sh bump

# Build APK using common build script
source ./build-common.sh

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

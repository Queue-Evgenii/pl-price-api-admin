#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
ADB="$SDK_ROOT/platform-tools/adb"
EMULATOR_BIN="$SDK_ROOT/emulator/emulator"
AVD_NAME="${1:-Medium_Phone_API_36.1}"

export ANDROID_SDK_ROOT="$SDK_ROOT"
export ANDROID_HOME="$SDK_ROOT"

# Setup version (bump patch + sync)
./version-setup.sh bump

# Build APK using common build script
source ./build-common.sh

find_aapt() {
    local aapt_path
    aapt_path="$(ls -t "$SDK_ROOT"/build-tools/*/aapt 2>/dev/null | head -n 1 || true)"
    echo "$aapt_path"
}

read_package_from_apk() {
    local apk_path="$1"
    local aapt_path="$2"

    if [ -x "${aapt_path:-}" ]; then
        "$aapt_path" dump badging "$apk_path" | awk -F"'" '/package: name=/{print $2; exit}'
        return
    fi

    echo ""
}

echo "APK готов: $(basename "$APK_FILE")"

if ! "$ADB" devices | awk 'NR>1 {print $2}' | grep -q '^device$'; then
    echo "Запуск эмулятора: $AVD_NAME"
    "$EMULATOR_BIN" -avd "$AVD_NAME" -no-audio > /dev/null 2>&1 &
fi

echo "Ожидание устройства..."
"$ADB" wait-for-device
until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
    sleep 2
done

echo "Установка APK..."
"$ADB" install -r "$APK_FILE"

AAPT_BIN="$(find_aapt)"
APP_ID="$(read_package_from_apk "$APK_FILE" "$AAPT_BIN")"
if [ -z "${APP_ID:-}" ]; then
    if "$ADB" shell pm list packages | grep -q "package:com.priceapi.admin.debug"; then
        APP_ID="com.priceapi.admin.debug"
    else
        APP_ID="com.priceapi.admin"
    fi
fi

echo "Запуск приложения: $APP_ID"
"$ADB" shell monkey -p "$APP_ID" -c android.intent.category.LAUNCHER 1 >/dev/null

echo "Готово. Установлен и запущен: $(basename "$APK_FILE") ($APP_ID)"

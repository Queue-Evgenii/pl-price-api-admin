#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
ADB="$SDK_ROOT/platform-tools/adb"
EMULATOR_BIN="$SDK_ROOT/emulator/emulator"
AVD_NAME="${1:-Medium_Phone_API_36.1}"

find_latest_apk() {
  local apk

  apk="$(ls -t \
    "$ROOT_DIR"/android/app/build/outputs/apk/debug/*.apk \
    "$ROOT_DIR"/android/app/build/outputs/apk/release/*.apk \
    2>/dev/null | head -n 1 || true)"
  if [ -n "${apk:-}" ]; then
    echo "$apk"
    return
  fi

  ls -t "$ROOT_DIR"/pl-price-*.apk 2>/dev/null | head -n 1 || true
}

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

if [ ! -x "$ADB" ]; then
  echo "adb не найден: $ADB"
  exit 1
fi

APK_FILE="$(find_latest_apk)"
if [ -z "${APK_FILE:-}" ]; then
  echo "APK не найден. Сначала собери его."
  exit 1
fi

if ! "$ADB" devices | awk 'NR>1 {print $2}' | grep -q '^device$'; then
  if [ ! -x "$EMULATOR_BIN" ]; then
    echo "emulator не найден: $EMULATOR_BIN"
    exit 1
  fi
  echo "Запуск эмулятора: $AVD_NAME"
  "$EMULATOR_BIN" -avd "$AVD_NAME" -no-audio > /dev/null 2>&1 &
fi

echo "Ожидание устройства..."
"$ADB" wait-for-device
until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
  sleep 2
done

echo "Установка APK: $(basename "$APK_FILE")"
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

echo "Готово: $(basename "$APK_FILE") запущен ($APP_ID)."

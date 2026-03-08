#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
ADB="$SDK_ROOT/platform-tools/adb"
EMULATOR_BIN="$SDK_ROOT/emulator/emulator"
AVD_NAME="${1:-Medium_Phone_API_36.1}"

export ANDROID_SDK_ROOT="$SDK_ROOT"
export ANDROID_HOME="$SDK_ROOT"

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

echo "Сборка фронта..."
cd "$ROOT_DIR"
npm run build

echo "Синхронизация Capacitor с Android..."
npx cap sync android

echo "Сборка debug APK..."
cd "$ROOT_DIR/android"
if [ ! -f "$ROOT_DIR/android/local.properties" ]; then
    echo "sdk.dir=$SDK_ROOT" > "$ROOT_DIR/android/local.properties"
fi
rm -f "$ROOT_DIR"/android/app/build/outputs/apk/debug/pl-price-*.apk
EXPECTED_TS="$(date +'%y%m%d-%H%M')"
echo "Ожидаемый шаблон имени APK: pl-price-<version>-${EXPECTED_TS}.apk"
./gradlew assembleDebug

APK_FILE="$(ls -t "$ROOT_DIR"/android/app/build/outputs/apk/debug/*.apk | head -n 1)"
if [ -z "${APK_FILE:-}" ]; then
    echo "Не удалось найти debug APK после сборки."
    exit 1
fi

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

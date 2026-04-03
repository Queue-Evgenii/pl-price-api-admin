#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
ADB="$SDK_ROOT/platform-tools/adb"
EMULATOR_BIN="$SDK_ROOT/emulator/emulator"
AVD_NAME="${1:-Medium_Phone_API_36.1}"
SCREENSHOT_DIR="$ROOT_DIR/screenshots"
APK_FILE="/Users/sundevil/domains/pl-price-api-admin/frontend/android/app/build/outputs/apk/debug/pl-price-2.0.11-260402-1119.apk"

# Create screenshots directory
mkdir -p "$SCREENSHOT_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    if [ ! -x "$ADB" ]; then
        error "adb не найден: $ADB"
        exit 1
    fi

    if [ ! -x "$EMULATOR_BIN" ]; then
        error "emulator не найден: $EMULATOR_BIN"
        exit 1
    fi

    if [ ! -f "$APK_FILE" ]; then
        error "APK файл не найден: $APK_FILE"
        exit 1
    fi
}

start_emulator() {
    log "Проверка состояния эмулятора..."
    
    if "$ADB" devices | awk 'NR>1 {print $2}' | grep -q '^device$'; then
        log "Эмулятор уже запущен"
        return
    fi

    log "Запуск эмулятора: $AVD_NAME"
    "$EMULATOR_BIN" -avd "$AVD_NAME" -no-audio -no-snapshot > /dev/null 2>&1 &
    
    log "Ожидание запуска эмулятора..."
    "$ADB" wait-for-device
    
    until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
        sleep 2
        echo -n "."
    done
    echo
    log "Эмулятор успешно запущен"
}

install_app() {
    log "Установка APK: $(basename "$APK_FILE")"
    "$ADB" install -r "$APK_FILE"
    
    APP_ID="$("$ADB" shell pm list packages | grep "com.priceapi.admin" | sed 's/package://' | head -n1)"
    
    if [ -z "$APP_ID" ]; then
        error "Не удалось определить package name приложения"
        exit 1
    fi
    
    log "Package ID: $APP_ID"
    echo "$APP_ID" > "$SCREENSHOT_DIR/package_id.txt"
}

take_screenshot() {
    local name="$1"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local filename="${name}_${timestamp}.png"
    local device_path="/sdcard/Pictures/$filename"
    local local_path="$SCREENSHOT_DIR/$filename"
    
    log "Создание скриншота: $filename"
    
    "$ADB" shell screencap -p "$device_path"
    "$ADB" pull "$device_path" "$local_path"
    "$ADB" shell rm "$device_path"
    
    log "Скриншот сохранен: $local_path"
}

navigate_and_screenshot() {
    local app_id="$1"
    local screen_name="$2"
    local wait_time="${3:-3}"
    
    log "Переход к экрану: $screen_name"
    sleep "$wait_time"
    take_screenshot "$screen_name"
}

auto_screenshots() {
    local app_id="$1"
    
    log "Запуск приложения для создания скриншотов"
    "$ADB" shell monkey -p "$app_id" -c android.intent.category.LAUNCHER 1 >/dev/null
    
    sleep 8  # Wait for app to fully load
    
    log "Создание скриншотов для Google Play Store..."
    
    # Screen 1: Главная страница со списком категорий
    log "Скриншот 1: Главная страница с категориями"
    "$ADB" shell monkey -p "$app_id" -c android.intent.category.LAUNCHER 1 >/dev/null
    sleep 3
    take_screenshot "01_main_categories"
    
    # Screen 2: Ждем пока пользователь перейдет в категорию
    log "Нажмите Enter когда перейдете в категорию для создания скриншота прайса..."
    read -r
    
    log "Скриншот 2: Страница категории с прайсом"
    take_screenshot "02_category_prices"
}

shutdown_emulator() {
    log "Закрытие эмулятора..."
    "$ADB" emu kill
    log "Эмулятор закрыт"
}

main() {
    log "Автоматическое создание скриншотов для Google Play"
    
    check_dependencies
    start_emulator
    install_app
    
    APP_ID="$(cat "$SCREENSHOT_DIR/package_id.txt")"
    auto_screenshots "$APP_ID"
    
    shutdown_emulator
    
    log "Готово! Скриншоты сохранены в: $SCREENSHOT_DIR"
    
    echo
    echo -e "${BLUE}Созданные скриншоты:${NC}"
    ls -la "$SCREENSHOT_DIR"/*.png 2>/dev/null | wc -l | xargs echo "Всего файлов:"
    ls -la "$SCREENSHOT_DIR"/*.png 2>/dev/null
    
    echo
    echo -e "${BLUE}Рекомендации для Google Play:${NC}"
    echo "- Выберите лучшие 2-8 скриншотов"
    echo "- Убедитесь что скриншоты показывают основные функции приложения"
    echo "- Скриншоты должны быть на русском языке (если приложение русифицировано)"
    echo "- Размер скриншотов должен соответствовать требованиям Google Play"
}

trap 'echo -e "\n${YELLOW}Прерывание скрипта...${NC}"; exit 130' INT

main "$@"

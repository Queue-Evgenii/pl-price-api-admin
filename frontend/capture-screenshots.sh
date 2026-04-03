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
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    
    # Check if emulator is already running
    if "$ADB" devices | awk 'NR>1 {print $2}' | grep -q '^device$'; then
        log "Эмулятор уже запущен"
        return
    fi

    log "Запуск эмулятора: $AVD_NAME"
    "$EMULATOR_BIN" -avd "$AVD_NAME" -no-audio -no-snapshot > /dev/null 2>&1 &
    
    log "Ожидание запуска эмулятора..."
    "$ADB" wait-for-device
    
    # Wait for boot to complete
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
    
    # Get package name
    APP_ID="$("$ADB" shell pm list packages | grep "com.priceapi.admin" | sed 's/package://' | head -n1)"
    
    if [ -z "$APP_ID" ]; then
        error "Не удалось определить package name приложения"
        exit 1
    fi
    
    log "Package ID: $APP_ID"
    echo "$APP_ID" > "$SCREENSHOT_DIR/package_id.txt"
}

launch_app() {
    local app_id="$1"
    log "Запуск приложения: $app_id"
    "$ADB" shell monkey -p "$app_id" -c android.intent.category.LAUNCHER 1 >/dev/null
    
    # Wait for app to load
    sleep 5
}

take_screenshot() {
    local name="$1"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local filename="${name}_${timestamp}.png"
    local device_path="/sdcard/Pictures/$filename"
    local local_path="$SCREENSHOT_DIR/$filename"
    
    log "Создание скриншота: $filename"
    
    # Take screenshot
    "$ADB" shell screencap -p "$device_path"
    
    # Pull to local
    "$ADB" pull "$device_path" "$local_path"
    
    # Clean up device
    "$ADB" shell rm "$device_path"
    
    log "Скриншот сохранен: $local_path"
}

wait_for_user_action() {
    echo
    echo -e "${BLUE}=== Инструкция ===${NC}"
    echo "1. Приложение запущено на эмуляторе"
    echo "2. Выполните нужные действия в приложении"
    echo "3. Нажмите Enter для создания скриншота"
    echo "4. Введите 'next' для перехода к следующему экрану"
    echo "5. Введите 'done' когда закончите"
    echo
    read -p "Нажмите Enter для скриншота или введите команду: " action
    
    case "$action" in
        "done")
            return 1
            ;;
        "next")
            return 2
            ;;
        *)
            return 0
            ;;
    esac
}

main() {
    log "Начало процесса создания скриншотов для Google Play"
    
    check_dependencies
    
    start_emulator
    install_app
    
    # Get app ID from saved file
    APP_ID="$(cat "$SCREENSHOT_DIR/package_id.txt")"
    
    # Launch app for first screenshot
    launch_app "$APP_ID"
    
    screenshot_count=0
    
    log "Начинаем создание скриншотов..."
    
    while true; do
        wait_for_user_action
        result=$?
        
        if [ $result -eq 1 ]; then
            log "Завершение создания скриншотов"
            break
        elif [ $result -eq 2 ]; then
            # Navigate to next screen (you can customize this)
            log "Переход к следующему экрану..."
            "$ADB" shell input keyevent KEYCODE_TAB
            sleep 2
        fi
        
        screenshot_count=$((screenshot_count + 1))
        take_screenshot "screen_$screenshot_count"
        
        if [ $screenshot_count -ge 8 ]; then
            warn "Достигнут максимум 8 скриншотов для Google Play"
            break
        fi
    done
    
    log "Готово! Создано скриншотов: $screenshot_count"
    log "Скриншоты сохранены в: $SCREENSHOT_DIR"
    
    # Show created screenshots
    echo
    echo -e "${BLUE}Созданные скриншоты:${NC}"
    ls -la "$SCREENSHOT_DIR"/*.png 2>/dev/null || echo "Скриншоты не найдены"
}

# Handle script interruption
trap 'echo -e "\n${YELLOW}Прерывание скрипта...${NC}"; exit 130' INT

main "$@"

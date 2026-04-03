#!/bin/bash
set -euo pipefail

# Common Android build script
# This script handles Java setup, Android SDK configuration, and APK building

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"

export ANDROID_SDK_ROOT="$SDK_ROOT"
export ANDROID_HOME="$SDK_ROOT"

setup_java() {
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
        echo "❌ Java (JDK) не найден. Установите JDK или Android Studio (встроенный JBR)."
        exit 1
    fi
}

build_frontend() {
    echo "🔨 Building frontend assets..."
    cd "$ROOT_DIR"
    npm run build

    if [ $? -ne 0 ]; then
        echo "❌ Frontend build failed!"
        exit 1
    fi
}

sync_capacitor() {
    echo "📦 Syncing Capacitor with Android..."
    npx cap sync android

    if [ $? -ne 0 ]; then
        echo "❌ Capacitor sync failed!"
        exit 1
    fi
}

build_apk() {
    echo "🏗️ Building debug APK..."
    cd "$ROOT_DIR/android"
    if [ ! -f "$ROOT_DIR/android/local.properties" ]; then
        echo "sdk.dir=$SDK_ROOT" > "$ROOT_DIR/android/local.properties"
    fi
    rm -f "$ROOT_DIR"/android/app/build/outputs/apk/debug/pl-price-*.apk
    EXPECTED_TS="$(date +'%y%m%d-%H%M')"
    echo "Expected APK name pattern: pl-price-<version>-${EXPECTED_TS}.apk"
    
    # Load environment variables from .env file
    if [ -f "$ROOT_DIR/.env" ]; then
        export $(grep -v '^#' "$ROOT_DIR/.env" | xargs)
    fi
    
    # Pass environment variables to Gradle
    ./gradlew assembleDebug -PAPP_VERSION_NAME="${APP_VERSION_NAME:-1.0}" -PAPP_VERSION_CODE="${APP_VERSION_CODE:-1}"

    if [ $? -ne 0 ]; then
        echo "❌ APK build failed!"
        exit 1
    fi

    APK_FILE="$(ls -t "$ROOT_DIR"/android/app/build/outputs/apk/debug/*.apk | head -n 1)"
    if [ -z "${APK_FILE:-}" ]; then
        echo "❌ Could not find debug APK after build."
        exit 1
    fi

    echo "✅ APK build completed successfully!"
    echo "📱 APK location: $(basename "$APK_FILE")"
    echo "📁 Full path: $APK_FILE"
    
    # Export APK_FILE for use by calling scripts
    export APK_FILE="$APK_FILE"
}

# Main execution
setup_java
build_frontend
sync_capacitor
build_apk

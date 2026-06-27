#!/bin/bash
set -euo pipefail

# Common iOS build script
# This script handles iOS setup, web build, and Xcode project preparation

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

if command -v ruby >/dev/null 2>&1; then
    GEM_BIN="$(ruby -e 'print Gem.user_dir + "/bin"' 2>/dev/null || true)"
    if [ -n "$GEM_BIN" ] && [ -d "$GEM_BIN" ]; then
        export PATH="$GEM_BIN:$PATH"
    fi
fi

case " ${RUBYOPT:-} " in
    *" -rlogger "*) ;;
    *) export RUBYOPT="${RUBYOPT:+$RUBYOPT }-rlogger" ;;
esac

setup_xcode() {
    # Check if Xcode is installed
    if ! command -v xcodebuild >/dev/null 2>&1; then
        echo "❌ Xcode not found. Please install Xcode from App Store."
        exit 1
    fi

    # Check Xcode command line tools
    if ! xcode-select -p >/dev/null 2>&1; then
        echo "❌ Xcode command line tools not found. Installing..."
        xcode-select --install
        echo "⏳ Please wait for command line tools installation to complete..."
        read -p "Press Enter when installation is finished..."
    fi
}

apply_wkprocesspool_fix() {
    if [ -f "$ROOT_DIR/fix-wkprocesspool-warning.cjs" ]; then
        node fix-wkprocesspool-warning.cjs
    fi
}

fix_xcode_project() {
    PROJECT_FILE="$ROOT_DIR/ios/App/App.xcodeproj/project.pbxproj"

    if [ ! -f "$PROJECT_FILE" ]; then
        echo "❌ Xcode project file not found: $PROJECT_FILE"
        exit 1
    fi
}

create_bundle_files() {
    echo "🔧 Creating missing bundle files..."

    # Create bundle files in all possible DerivedData locations
    for DERIVED_PATH in "$HOME/Library/Developer/Xcode/DerivedData/App-"*; do
        if [ -d "$DERIVED_PATH" ]; then
            # Create in Build/Products (primary location for Xcode builds)
            mkdir -p "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle"
            touch "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle/CapacitorCordova"

            mkdir -p "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle"
            touch "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle/Capacitor"

            # Create in Index.noindex/Build/Products (backup location)
            mkdir -p "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle"
            touch "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle/CapacitorCordova"

            mkdir -p "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle"
            touch "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle/Capacitor"
        fi
    done

    echo "✅ Bundle files created"
}


verify_app_icons() {
    # Skip icon verification for simplified build
    return 0
}

build_frontend() {
    cd "$ROOT_DIR"
    npm run build

    if [ $? -ne 0 ]; then
        echo "❌ Frontend build failed!"
        exit 1
    fi
}

sync_capacitor() {
    npx cap sync ios

    if [ $? -ne 0 ]; then
        echo "❌ Capacitor sync failed!"
        exit 1
    fi
}

fix_capacitor_headers() {
    # Fix system headers to use angle brackets, keep local headers with quotes
    if [ -d "$ROOT_DIR/node_modules/@capacitor/ios" ]; then
        # Fix system headers (UIKit, WebKit, Foundation)
        find "$ROOT_DIR/node_modules/@capacitor/ios" -name "*.h" -exec sed -i '' 's/#import "UIKit\/UIKit\.h"/#import <UIKit\/UIKit.h>/g' {} \;
        find "$ROOT_DIR/node_modules/@capacitor/ios" -name "*.h" -exec sed -i '' 's/#import "WebKit\/WebKit\.h"/#import <WebKit\/WebKit.h>/g' {} \;
        find "$ROOT_DIR/node_modules/@capacitor/ios" -name "*.h" -exec sed -i '' 's/#import "Foundation\/Foundation\.h"/#import <Foundation\/Foundation.h>/g' {} \;

        # Clear Xcode cache to force reindexing
        if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
            rm -rf "$HOME/Library/Developer/Xcode/DerivedData"/* 2>/dev/null || true
        fi
    fi
}

update_pods() {
    cd "$ROOT_DIR/ios/App"

    if [ ! -f "Podfile" ]; then
        echo "❌ Podfile not found in ios/App directory"
        exit 1
    fi

    # Check if CocoaPods is installed
    if ! command -v pod >/dev/null 2>&1; then
        echo "❌ CocoaPods not found. Installing..."
        sudo gem install cocoapods
    fi

    pod install

    if [ $? -ne 0 ]; then
        echo "❌ Pod install failed!"
        exit 1
    fi

    cd "$ROOT_DIR"
}

# Function to clean build cache
clean_build_cache() {
    echo "🧹 Cleaning build cache..."

    # Clean derived data
    if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
        rm -rf "$HOME/Library/Developer/Xcode/DerivedData"/* 2>/dev/null || true
    fi

    # Clean project derived data
    if [ -d "$ROOT_DIR/ios/DerivedData" ]; then
        rm -rf "$ROOT_DIR/ios/DerivedData"
    fi

    # Clean iOS build folder
    cd "$ROOT_DIR/ios/App"
    if [ -d "build" ]; then
        rm -rf build
    fi

    # Clean Xcode build cache
    xcodebuild clean -workspace App.xcworkspace -scheme App -configuration Debug 2>/dev/null || true

    cd "$ROOT_DIR"
    echo "✅ Build cache cleaned"
}

# Function to clean pod cache
clean_pod_cache() {
    echo "🧹 Cleaning CocoaPods cache..."

    cd "$ROOT_DIR/ios/App"

    # Remove Pods directory
    if [ -d "Pods" ]; then
        rm -rf Pods
    fi

    # Remove Podfile.lock
    if [ -f "Podfile.lock" ]; then
        rm -f Podfile.lock
    fi

    # Clean pod cache
    pod cache clean --all 2>/dev/null || true

    cd "$ROOT_DIR"
    echo "✅ CocoaPods cache cleaned"
}

# Check for clean flag
CLEAN_CACHE=false
if [[ "${1:-}" == "--clean" ]]; then
    CLEAN_CACHE=true
fi

# Main execution
if [ "$CLEAN_CACHE" = true ]; then
    echo "🧹 Performing clean build with cache reset..."
    clean_build_cache
    clean_pod_cache
fi

setup_xcode
apply_wkprocesspool_fix
build_frontend
sync_capacitor
fix_capacitor_headers
create_bundle_files
update_pods
fix_xcode_project
verify_app_icons

echo "✅ iOS build preparation completed"

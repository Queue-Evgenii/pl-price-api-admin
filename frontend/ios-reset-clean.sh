#!/bin/bash

# iOS Full Reset and Clean Build Script
# This script performs complete cleanup, builds, and manages Xcode/simulator state

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"
SIMULATOR_NAME="${1:-iPhone 15 Pro}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check if Xcode is running
is_xcode_running() {
    pgrep -f "Xcode" >/dev/null 2>&1
}

# Function to close Xcode
close_xcode() {
    if is_xcode_running; then
        print_step "Closing Xcode..."
        osascript -e 'tell application "Xcode" to quit'
        sleep 3
    else
        print_status "Xcode is not running"
    fi
}

# Function to open Xcode
open_xcode() {
    print_step "Opening Xcode workspace..."
    open "$ROOT_DIR/ios/App/App.xcworkspace"
    sleep 5
}

# Function to get simulator UDID by name
get_simulator_udid() {
    local name="$1"
    xcrun simctl list devices | grep "$name" | grep -E "Booted|Shutdown" | head -1 | grep -oE "\([A-F0-9\-]+\)" | tr -d "()"
}

# Function to check if simulator is running
is_simulator_running() {
    local udid="$1"
    xcrun simctl list devices | grep "$udid" | grep -q "Booted"
}

# Function to close all simulators
close_simulators() {
    print_step "Closing all simulators..."
    # Kill Simulator app
    pkill -f "Simulator" || true
    sleep 2

    # Shutdown all booted simulators
    xcrun simctl list devices | grep "Booted" | grep -oE "\([A-F0-9\-]+\)" | tr -d "()" | while read -r udid; do
        xcrun simctl shutdown "$udid" || true
    done
    sleep 2
}

# Function to start simulator
start_simulator() {
    local name="$1"
    local udid

    udid=$(get_simulator_udid "$name")

    if [ -z "$udid" ]; then
        print_error "Simulator '$name' not found. Available simulators:"
        xcrun simctl list devices | grep -E "iPhone|iPad" | grep -v "unavailable"
        return 1
    fi

    print_step "Starting simulator: $name ($udid)"
    xcrun simctl boot "$udid"

    # Wait for simulator to boot
    for i in {1..60}; do
        if is_simulator_running "$udid"; then
            print_status "Simulator is ready!"
            break
        fi
        sleep 1
    done

    # Open Simulator app
    open -a Simulator
    sleep 3
}

# Function to clean build cache
clean_build_cache() {
    print_step "Cleaning build cache..."

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
    print_status "Build cache cleaned"
}

# Function to clean pod cache
clean_pod_cache() {
    print_step "Cleaning CocoaPods cache..."

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
    print_status "CocoaPods cache cleaned"
}

# Function to reset capacitor
reset_capacitor() {
    print_step "Resetting Capacitor..."

    # Remove iOS platform and add it back
    npx cap rm ios 2>/dev/null || true
    npx cap add ios

    print_status "Capacitor reset completed"
}

# Main execution
echo "🔄 iOS Full Reset and Clean Build Process"
echo "======================================="

# Step 1: Close Xcode and simulators
print_step "Step 1: Closing Xcode and simulators..."
close_xcode
close_simulators

# Step 2: Setup version
print_step "Step 2: Setting up version..."
./version-setup.sh bump

# Step 3: Clean everything
print_step "Step 3: Cleaning caches and build artifacts..."
clean_build_cache
clean_pod_cache

# Step 4: Build frontend
print_step "Step 4: Building frontend..."
npm run build

# Step 5: Reset and sync Capacitor
print_step "Step 5: Resetting and syncing Capacitor..."
reset_capacitor
npx cap sync ios

# Step 6: Install pods
print_step "Step 6: Installing CocoaPods..."
cd "$ROOT_DIR/ios/App"
pod install
cd "$ROOT_DIR"

# Step 7: Apply fixes
print_step "Step 7: Applying iOS fixes..."
if [ -f "$ROOT_DIR/fix-wkprocesspool-warning.cjs" ]; then
    node fix-wkprocesspool-warning.cjs
fi

# Step 8: Start simulator
print_step "Step 8: Starting simulator..."
start_simulator "$SIMULATOR_NAME"

# Step 9: Open Xcode
print_step "Step 9: Opening Xcode..."
open_xcode

# Step 10: Build and run
print_step "Step 10: Building and running app..."
cd "$ROOT_DIR/ios/App"

SIMULATOR_UDID=$(get_simulator_udid "$SIMULATOR_NAME")
xcodebuild -workspace App.xcworkspace \
           -scheme App \
           -configuration Debug \
           -destination "id=$SIMULATOR_UDID" \
           -derivedDataPath "$ROOT_DIR/ios/DerivedData" \
           clean build

if [ $? -eq 0 ]; then
    # Install and launch
    APP_PATH="$ROOT_DIR/ios/DerivedData/Build/Products/Debug-iphonesimulator/App.app"

    if [ -d "$APP_PATH" ]; then
        xcrun simctl install "$SIMULATOR_UDID" "$APP_PATH"
        BUNDLE_ID=$(plutil -raw -extract CFBundleIdentifier - "$APP_PATH/Info.plist")
        xcrun simctl launch "$SIMULATOR_UDID" "$BUNDLE_ID"

        echo ""
        echo "🎉 Full reset and clean build completed successfully!"
        echo "📱 App is running on: $SIMULATOR_NAME"
        echo "📦 Bundle ID: $BUNDLE_ID"
        echo "🔧 Xcode is open with the project"
    else
        print_error "Built app not found"
    fi
else
    print_error "Build failed"
fi

cd "$ROOT_DIR"
echo ""
echo "✅ Process completed!"
echo "💡 All caches cleared, fresh build installed"

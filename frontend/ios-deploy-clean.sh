#!/bin/bash

# iOS deployment script - build and open Xcode only
# Simplified version without simulator management

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

echo "🔄 Building iOS app and opening Xcode..."

# Setup version (bump patch + sync)
./version-setup.sh bump

# Build using common build script
source ./ios-common.sh

# Clean Xcode cache before opening
echo "🧹 Cleaning Xcode cache..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*
cd "$ROOT_DIR/ios/App"
xcodebuild clean -workspace App.xcworkspace -scheme App > /dev/null 2>&1
cd "$ROOT_DIR"

# Create missing bundle files before opening Xcode
echo "🔧 Creating missing bundle files before Xcode..."
for DERIVED_PATH in "$HOME/Library/Developer/Xcode/DerivedData/App-"*; do
    if [ -d "$DERIVED_PATH" ]; then
        # Create in Build/Products
        mkdir -p "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle"
        touch "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle/CapacitorCordova"

        mkdir -p "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle"
        touch "$DERIVED_PATH/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle/Capacitor"

        # Create in Index.noindex/Build/Products
        mkdir -p "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle"
        touch "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/CapacitorCordova/CapacitorCordova.bundle/CapacitorCordova"

        mkdir -p "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle"
        touch "$DERIVED_PATH/Index.noindex/Build/Products/Debug-iphonesimulator/Capacitor/Capacitor.bundle/Capacitor"
    fi
done
echo "✅ Bundle files created for Xcode"

# Open Xcode for build monitoring
echo "🔄 Opening Xcode workspace..."
open "$ROOT_DIR/ios/App/App.xcworkspace"

echo "✅ Build completed and Xcode opened"
echo "📱 You can now run the app from Xcode (Cmd+R)"

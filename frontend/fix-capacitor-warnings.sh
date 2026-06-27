#!/bin/bash

# Fix Capacitor iOS warnings for iOS 18
# This script patches the deprecated API warnings in Capacitor files

CAPACITOR_PATH="$ROOT_DIR/node_modules/@capacitor/ios/Capacitor/Capacitor"

if [ ! -d "$CAPACITOR_PATH" ]; then
    echo "❌ Capacitor path not found: $CAPACITOR_PATH"
    exit 1
fi

echo "🔧 Fixing Capacitor iOS warnings..."

# Fix CapacitorBridge.swift - replace deprecated tmpVCAppeared and tmpWindow
BRIDGE_FILE="$CAPACITOR_PATH/CapacitorBridge.swift"
if [ -f "$BRIDGE_FILE" ]; then
    echo "Fixing CapacitorBridge.swift..."

    # Create backup
    cp "$BRIDGE_FILE" "$BRIDGE_FILE.backup"

    # Replace deprecated API calls with modern equivalents
    sed -i '' 's/tmpVCAppeared/isBeingPresented/g' "$BRIDGE_FILE"
    sed -i '' 's/tmpWindow/view.window/g' "$BRIDGE_FILE"

    echo "✅ CapacitorBridge.swift fixed"
fi

# Fix TmpViewController.swift - replace deprecated tmpVCAppeared
TMPVIEW_FILE="$CAPACITOR_PATH/TmpViewController.swift"
if [ -f "$TMPVIEW_FILE" ]; then
    echo "Fixing TmpViewController.swift..."

    # Create backup
    cp "$TMPVIEW_FILE" "$TMPVIEW_FILE.backup"

    # Replace deprecated API call
    sed -i '' 's/tmpVCAppeared/isBeingPresented/g' "$TMPVIEW_FILE"

    echo "✅ TmpViewController.swift fixed"
fi

echo "✅ Capacitor iOS warnings fixed"

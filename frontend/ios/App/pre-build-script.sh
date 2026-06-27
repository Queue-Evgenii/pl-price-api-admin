#!/bin/bash

# Pre-build script to create missing bundle files
echo "Creating missing bundle files..."

# Create CapacitorCordova bundle file
BUNDLE_PATH="${BUILT_PRODUCTS_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/CapacitorCordova/CapacitorCordova.bundle"
mkdir -p "$BUNDLE_PATH"
touch "$BUNDLE_PATH/CapacitorCordova"

# Create Capacitor bundle file  
BUNDLE_PATH="${BUILT_PRODUCTS_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/Capacitor/Capacitor.bundle"
mkdir -p "$BUNDLE_PATH"
touch "$BUNDLE_PATH/Capacitor"

echo "Bundle files created successfully"

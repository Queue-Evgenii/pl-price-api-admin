#!/bin/bash

# iOS Build Script for pl-price-api-admin
# This script prepares and builds the iOS project for Xcode

set -e

echo "🚀 Starting iOS build process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the correct directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the frontend directory."
    exit 1
fi

# Step 1: Install dependencies
print_status "Installing dependencies..."
npm install

# Step 2: Apply WKProcessPool fix
print_status "Applying WKProcessPool deprecation fix..."
if [ -f "fix-wkprocesspool-warning.cjs" ]; then
    node fix-wkprocesspool-warning.cjs
    print_status "WKProcessPool fix applied successfully"
else
    print_warning "WKProcessPool fix script not found, skipping..."
fi

# Step 3: Build the web app
print_status "Building web application..."
npm run build

# Step 4: Sync with Capacitor
print_status "Syncing with Capacitor..."
npx cap sync ios

# Step 5: Update iOS pods
print_status "Updating iOS pods..."
cd ios/App
pod install
cd ../..

# Step 6: Apply Xcode project fixes
print_status "Applying Xcode project fixes..."

# Check if outputPaths are already fixed
if grep -q "outputPaths = (" "ios/App/App.xcodeproj/project.pbxproj" && grep -q "Capacitor.framework" "ios/App/App.xcodeproj/project.pbxproj"; then
    print_status "Xcode project fixes already applied"
else
    print_warning "Xcode project fixes may need manual verification"
fi

# Step 7: Verify icon sizes
print_status "Verifying app icon sizes..."

ICON_DIR="ios/App/App/Assets.xcassets/AppIcon.appiconset"
if [ -f "$ICON_DIR/AppIcon-57@2x.png" ]; then
    SIZE=$(file "$ICON_DIR/AppIcon-57@2x.png" | grep -o '[0-9]* x [0-9]*')
    if [[ "$SIZE" == "114 x 114" ]]; then
        print_status "AppIcon-57@2x.png has correct size: $SIZE"
    else
        print_warning "AppIcon-57@2x.png has incorrect size: $SIZE (should be 114 x 114)"
    fi
fi

echo ""
echo "✅ iOS build process completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Open ios/App/App.xcworkspace in Xcode"
echo "   2. Select your target device/simulator"
echo "   3. Press Cmd+R to run the application"
echo ""
echo "🔧 If you encounter any issues, check the troubleshooting section in iOS-README.md"

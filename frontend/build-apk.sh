#!/bin/bash

# Build APK for manual testing on Android device
# This script creates a debug APK that can be installed directly on a phone

set -e  # Exit on any error

# Set JAVA_HOME for macOS
export JAVA_HOME=/opt/homebrew/opt/openjdk@17

echo "🔨 Starting APK build process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the frontend directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the frontend directory."
    exit 1
fi

# Check if Android directory exists
if [ ! -d "android" ]; then
    print_error "Android directory not found. Please make sure Capacitor is properly configured."
    exit 1
fi

# Clean previous builds
print_status "Cleaning previous builds..."
rm -rf dist/
rm -rf android/app/build/outputs/apk/

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies..."
    npm install
fi

# Build the web app
print_status "Building web application..."
npm run build

if [ $? -ne 0 ]; then
    print_error "Web build failed"
    exit 1
fi

print_success "Web build completed"

# Sync with Capacitor
print_status "Syncing with Capacitor..."
npx cap sync android

if [ $? -ne 0 ]; then
    print_error "Capacitor sync failed"
    exit 1
fi

print_success "Capacitor sync completed"

# Build debug APK
print_status "Building debug APK..."
cd android

# Make gradlew executable
chmod +x gradlew

# Build debug APK
./gradlew assembleDebug

if [ $? -ne 0 ]; then
    print_error "APK build failed"
    exit 1
fi

print_success "APK build completed"

# Find the built APK
APK_PATH=$(find app/build/outputs/apk/debug -name "*.apk" | head -1)

if [ -z "$APK_PATH" ]; then
    print_error "APK file not found"
    exit 1
fi

# Get APK info
APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
APK_NAME=$(basename "$APK_PATH")

cd ..

print_success "APK build successful!"
echo ""
echo -e "${GREEN}📱 APK Information:${NC}"
echo -e "   File: ${APK_NAME}"
echo -e "   Size: ${APK_SIZE}"
echo -e "   Path: ${APK_PATH}"
echo ""

# Instructions for installation
echo -e "${BLUE}📋 Installation Instructions:${NC}"
echo -e "1. ${YELLOW}Enable Developer Options${NC} on your Android device:"
echo -e "   - Go to Settings > About phone"
echo -e "   - Tap 'Build number' 7 times"
echo ""
echo -e "2. ${YELLOW}Enable USB Debugging${NC}:"
echo -e "   - Go to Settings > Developer options"
echo -e "   - Enable 'USB debugging'"
echo ""
echo -e "3. ${YELLOW}Install APK${NC}:"
echo -e "   - Connect your phone via USB"
echo -e "   - Transfer the APK file to your phone"
echo -e "   - Open the APK file and install it"
echo -e "   - Or use ADB: adb install ${APK_PATH}"
echo ""

# Optional: Install via ADB if device is connected
if command -v adb &> /dev/null; then
    if adb devices | grep -q "device$"; then
        print_status "Android device detected via ADB"
        read -p "Do you want to install the APK directly via ADB? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Installing APK via ADB..."
            adb install "$APK_PATH"
            if [ $? -eq 0 ]; then
                print_success "APK installed successfully on device!"
            else
                print_error "APK installation failed"
            fi
        fi
    else
        print_warning "No Android device detected via ADB"
    fi
else
    print_warning "ADB not found. Please install Android SDK Platform Tools for direct installation."
fi

echo -e "${GREEN}✅ Build process completed!${NC}"

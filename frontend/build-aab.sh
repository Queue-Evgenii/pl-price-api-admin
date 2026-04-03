#!/bin/bash

# Build AAB for Google Play Store Production
# Creates signed Android App Bundle ready for Google Play Console

set -e  # Exit on any error

echo "🔨 Building Production AAB for Google Play Store..."

# Load environment variables from .env file
if [[ -f ".env" ]]; then
    echo "📝 Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
    echo "✅ Environment variables loaded"
else
    echo "⚠️  .env file not found, using system environment variables"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get version from package.json
VERSION=$(node -p "require('./package.json').version")
DATE=$(date '+%y%m%d-%H%M')

echo -e "${BLUE}Version: ${VERSION}${NC}"
echo -e "${BLUE}Date: ${DATE}${NC}"

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java not found. Please install Java 17+${NC}"
    exit 1
fi

# Set Java Home (macOS with Homebrew)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export JAVA_HOME=/opt/homebrew/opt/openjdk@17
    echo -e "${YELLOW}📍 Java Home: $JAVA_HOME${NC}"
fi

# Check if keystore exists
KEYSTORE_PATH="android/pl-price-release.keystore"
if [[ ! -f "$KEYSTORE_PATH" ]]; then
    echo -e "${RED}❌ Keystore not found at $KEYSTORE_PATH${NC}"
    echo "Please create keystore first or check the path"
    exit 1
fi

# Check signing environment variables
if [[ -z "$SIGNING_STORE_PASSWORD" || -z "$SIGNING_KEY_ALIAS" || -z "$SIGNING_KEY_PASSWORD" ]]; then
    echo -e "${RED}❌ Signing environment variables not set${NC}"
    echo "Please set:"
    echo "  export SIGNING_STORE_PASSWORD=your_password"
    echo "  export SIGNING_KEY_ALIAS=pl-price"
    echo "  export SIGNING_KEY_PASSWORD=your_password"
    exit 1
fi

echo -e "${GREEN}✅ Environment check passed${NC}"

# Step 1: Build web assets
echo -e "${BLUE}📦 Building web assets...${NC}"
npm run build
if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Web build failed${NC}"
    exit 1
fi

# Step 2: Sync assets with Capacitor
echo -e "${BLUE}🔄 Syncing assets with Capacitor...${NC}"
npx cap sync android

# Step 3: Build AAB
echo -e "${BLUE}🔨 Building AAB...${NC}"
cd android

./gradlew bundle
if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ AAB build failed${NC}"
    exit 1
fi

# Step 4: Clean old AAB files and rename new one
echo -e "${BLUE}🏷️  Renaming AAB file...${NC}"
AAB_PATH="app/build/outputs/bundle/release/app-release.aab"
NEW_NAME="pl-price-${VERSION}-${DATE}.aab"
OUTPUT_DIR="app/build/outputs/bundle/release"

# Clean old AAB files
echo -e "${BLUE}🧹 Cleaning old AAB files...${NC}"
find "$OUTPUT_DIR" -name "pl-price-*.aab" -type f -delete 2>/dev/null || true

if [[ -f "$AAB_PATH" ]]; then
    mv "$AAB_PATH" "$OUTPUT_DIR/$NEW_NAME"
    echo -e "${GREEN}✅ AAB renamed to: $NEW_NAME${NC}"
    
    # Show file info
    SIZE=$(du -h "$OUTPUT_DIR/$NEW_NAME" | cut -f1)
    echo -e "${GREEN}📊 File size: $SIZE${NC}"
    echo -e "${GREEN}📍 Location: android/$OUTPUT_DIR/$NEW_NAME${NC}"
else
    echo -e "${RED}❌ AAB file not found at $AAB_PATH${NC}"
    exit 1
fi

cd ..

# Step 5: Verify signature
echo -e "${BLUE}🔐 Verifying AAB signature...${NC}"
cd android
jarsigner -verify -verbose -certs "$OUTPUT_DIR/$NEW_NAME" | head -5
cd ..

echo -e "${GREEN}🎉 Production AAB build completed successfully!${NC}"
echo -e "${GREEN}📱 Ready for Google Play Console upload${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo -e "   📦 File: android/$OUTPUT_DIR/$NEW_NAME"
echo -e "   📊 Size: $SIZE"
echo -e "   🏷️  Version: $VERSION"
echo -e "   📅 Date: $DATE"
echo ""
echo -e "${YELLOW}🚀 Next steps:${NC}"
echo -e "   1. Upload to Google Play Console"
echo -e "   2. Fill app store listing"
echo -e "   3. Submit for review"

#!/bin/bash

# Build script with version bump
# This script bumps version and then builds APK
# Usage: ./build-with-version-bump.sh [patch|minor|major|version_number]

set -e

TYPE=${1:-patch}

echo "🚀 Starting build process with version bump..."

# Bump version
if [[ $TYPE =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "📦 Setting version to $TYPE"
    npm run version:set $TYPE
else
    echo "📦 Bumping $TYPE version"
    npm run version:bump:$TYPE
fi

# Show new version
echo "📋 Current version info:"
npm run version:current

# Build APK
echo "🔨 Building APK..."
npm run build-apk

# Show result
echo "✅ Build complete!"
echo "📱 APK location: android/app/build/outputs/apk/debug/"
ls -la android/app/build/outputs/apk/debug/*.apk

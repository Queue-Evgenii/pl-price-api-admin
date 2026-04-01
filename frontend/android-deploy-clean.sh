#!/bin/bash

# Android deployment with full emulator restart
# Use this when changes don't appear due to caching

echo "🔄 Full Android deployment with emulator restart..."

# Build the application
echo "🔨 Building the application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Full deployment
echo "📦 Deploying to Android..."
./deploy.sh

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed!"
    exit 1
fi

# Force restart emulator to clear cache
echo "🔄 Restarting emulator to clear cache..."
adb shell reboot

# Wait for emulator to restart
echo "⏳ Waiting for emulator restart..."
sleep 10

# Wait for device to be ready
echo "📱 Waiting for device..."
adb wait-for-device
until [ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
    sleep 2
done

# Reinstall and launch app
echo "📦 Reinstalling app..."
APK_FILE="$(ls -t android/app/build/outputs/apk/debug/*.apk | head -n 1)"
adb install -r "$APK_FILE"

APP_ID="com.priceapi.admin.debug"
echo "🚀 Launching application: $APP_ID"
adb shell monkey -p "$APP_ID" -c android.intent.category.LAUNCHER 1 >/dev/null

echo "🎉 Full deployment completed! Emulator restarted to clear cache."

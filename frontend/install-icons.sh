#!/bin/bash

# Install generated icons to their respective locations

GENERATED_DIR="generated-icons"

echo "Installing app icons..."

# Copy web favicons to public directory
echo "Copying web favicons..."
cp "$GENERATED_DIR/favicon-16x16.png" "public/favicon-16x16.png"
cp "$GENERATED_DIR/favicon-32x32.png" "public/favicon-32x32.png"
cp "$GENERATED_DIR/favicon-48x48.png" "public/favicon-48x48.png"
cp "$GENERATED_DIR/favicon-64x64.png" "public/favicon-64x64.png"
cp "$GENERATED_DIR/favicon-128x128.png" "public/favicon-128x128.png"
cp "$GENERATED_DIR/favicon-256x256.png" "public/favicon-256x256.png"
cp "$GENERATED_DIR/favicon.ico" "public/favicon.ico"

# Update main favicon files
cp "$GENERATED_DIR/favicon-32x32.png" "public/favicon.png"
cp "$GENERATED_DIR/favicon.ico" "public/favicon.ico"

# Copy iOS icons
echo "Copying iOS icons..."
IOS_DIR="ios/App/App/Assets.xcassets/AppIcon.appiconset"
if [ -d "$IOS_DIR" ]; then
    cp "$GENERATED_DIR/AppIcon-20@1x.png" "$IOS_DIR/AppIcon-20@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-20.png" "$IOS_DIR/AppIcon-20@1x.png"
    cp "$GENERATED_DIR/AppIcon-20@2x.png" "$IOS_DIR/AppIcon-20@2x.png"
    cp "$GENERATED_DIR/AppIcon-20@3x.png" "$IOS_DIR/AppIcon-20@3x.png"
    cp "$GENERATED_DIR/AppIcon-29@1x.png" "$IOS_DIR/AppIcon-29@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-29.png" "$IOS_DIR/AppIcon-29@1x.png"
    cp "$GENERATED_DIR/AppIcon-29@2x.png" "$IOS_DIR/AppIcon-29@2x.png"
    cp "$GENERATED_DIR/AppIcon-29@3x.png" "$IOS_DIR/AppIcon-29@3x.png"
    cp "$GENERATED_DIR/AppIcon-40@1x.png" "$IOS_DIR/AppIcon-40@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-40.png" "$IOS_DIR/AppIcon-40@1x.png"
    cp "$GENERATED_DIR/AppIcon-40@2x.png" "$IOS_DIR/AppIcon-40@2x.png"
    cp "$GENERATED_DIR/AppIcon-40@3x.png" "$IOS_DIR/AppIcon-40@3x.png"
    cp "$GENERATED_DIR/AppIcon-57@1x.png" "$IOS_DIR/AppIcon-57@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-57.png" "$IOS_DIR/AppIcon-57@1x.png"
    cp "$GENERATED_DIR/AppIcon-57@2x.png" "$IOS_DIR/AppIcon-57@2x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-114.png" "$IOS_DIR/AppIcon-57@2x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-60.png" "$IOS_DIR/AppIcon-57@2x.png"
    cp "$GENERATED_DIR/AppIcon-60@1x.png" "$IOS_DIR/AppIcon-60@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-60.png" "$IOS_DIR/AppIcon-60@1x.png"
    cp "$GENERATED_DIR/AppIcon-60@2x.png" "$IOS_DIR/AppIcon-60@2x.png"
    cp "$GENERATED_DIR/AppIcon-60@3x.png" "$IOS_DIR/AppIcon-60@3x.png"
    cp "$GENERATED_DIR/AppIcon-72@1x.png" "$IOS_DIR/AppIcon-72@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-72.png" "$IOS_DIR/AppIcon-72@1x.png"
    cp "$GENERATED_DIR/AppIcon-72@2x.png" "$IOS_DIR/AppIcon-72@2x.png"
    cp "$GENERATED_DIR/AppIcon-76@1x.png" "$IOS_DIR/AppIcon-76@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-76.png" "$IOS_DIR/AppIcon-76@1x.png"
    cp "$GENERATED_DIR/AppIcon-76@2x.png" "$IOS_DIR/AppIcon-76@2x.png"
    cp "$GENERATED_DIR/AppIcon-83.5@2x.png" "$IOS_DIR/AppIcon-83.5@2x.png"
    cp "$GENERATED_DIR/AppIcon-87@1x.png" "$IOS_DIR/AppIcon-87@1x.png" 2>/dev/null || cp "$GENERATED_DIR/AppIcon-87.png" "$IOS_DIR/AppIcon-87@1x.png"
    cp "$GENERATED_DIR/AppIcon-120.png" "$IOS_DIR/AppIcon-60@2x.png"
    cp "$GENERATED_DIR/AppIcon-152.png" "$IOS_DIR/AppIcon-76@2x.png"
    cp "$GENERATED_DIR/AppIcon-167.png" "$IOS_DIR/AppIcon-83.5@2x.png"
    cp "$GENERATED_DIR/AppIcon-180.png" "$IOS_DIR/AppIcon-60@3x.png"
    cp "$GENERATED_DIR/AppIcon-1024.png" "$IOS_DIR/AppIcon-512@2x.png"
else
    echo "iOS directory not found: $IOS_DIR"
fi

# Copy Android icons
echo "Copying Android icons..."
ANDROID_DIRS=(
    "android/app/src/main/res/mipmap-mdpi"
    "android/app/src/main/res/mipmap-hdpi"
    "android/app/src/main/res/mipmap-xhdpi"
    "android/app/src/main/res/mipmap-xxhdpi"
    "android/app/src/main/res/mipmap-xxxhdpi"
)

ANDROID_SIZES=(36 48 72 96 144 192)

for i in "${!ANDROID_DIRS[@]}"; do
    DIR="${ANDROID_DIRS[$i]}"
    if [ "$i" -lt "${#ANDROID_SIZES[@]}" ]; then
        SIZE="${ANDROID_SIZES[$i]}"
        if [ -d "$DIR" ]; then
            cp "$GENERATED_DIR/ic_launcher_${SIZE}.png" "$DIR/ic_launcher.png"
            echo "Copied ic launcher ${SIZE} to $DIR"
        else
            echo "Android directory not found: $DIR"
        fi
    fi
done

# Copy adaptive icon foregrounds
echo "Copying Android adaptive icons..."
ADAPTIVE_DIRS=(
    "android/app/src/main/res/drawable-mdpi"
    "android/app/src/main/res/drawable-hdpi"
    "android/app/src/main/res/drawable-xhdpi"
    "android/app/src/main/res/drawable-xxhdpi"
    "android/app/src/main/res/drawable-xxxhdpi"
)

for i in "${!ADAPTIVE_DIRS[@]}"; do
    DIR="${ADAPTIVE_DIRS[$i]}"
    if [ "$i" -lt "${#ANDROID_SIZES[@]}" ]; then
        SIZE="${ANDROID_SIZES[$i]}"
        if [ -d "$DIR" ]; then
            cp "$GENERATED_DIR/ic_launcher_foreground_${SIZE}.png" "$DIR/ic_launcher_foreground.png"
            echo "Copied adaptive icon ${SIZE} to $DIR"
        else
            echo "Android adaptive directory not found: $DIR"
        fi
    fi
done

# Copy to v26 directories (adaptive icons)
echo "Copying Android adaptive icons to v26 directories..."
V26_DIRS=(
    "android/app/src/main/res/drawable-mdpi-v26"
    "android/app/src/main/res/drawable-hdpi-v26"
    "android/app/src/main/res/drawable-xhdpi-v26"
    "android/app/src/main/res/drawable-xxhdpi-v26"
    "android/app/src/main/res/drawable-xxxhdpi-v26"
)

for i in "${!V26_DIRS[@]}"; do
    DIR="${V26_DIRS[$i]}"
    if [ "$i" -lt "${#ANDROID_SIZES[@]}" ]; then
        SIZE="${ANDROID_SIZES[$i]}"
        if [ -d "$DIR" ]; then
            cp "$GENERATED_DIR/ic_launcher_foreground_${SIZE}.png" "$DIR/ic_launcher_foreground.png"
            echo "Copied adaptive icon ${SIZE} to $DIR"
        fi
    fi
done

echo ""
echo "Icon installation complete!"
echo ""
echo "Next steps:"
echo "1. Rebuild your app to see the new icons"
echo "2. For iOS: Clean and rebuild the project in Xcode"
echo "3. For Android: Clean and rebuild the project in Android Studio"
echo "4. For web: Restart your development server"

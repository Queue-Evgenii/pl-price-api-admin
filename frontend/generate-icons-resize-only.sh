#!/bin/bash

# Generate app icons by resizing original logo only
# This script preserves the original logo design and only changes size

LOGO_PATH="src/assets/logo.png"
OUTPUT_DIR="generated-icons"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    echo "ImageMagick is not installed. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install imagemagick
    else
        echo "Please install ImageMagick manually"
        exit 1
    fi
fi

# Use magick if available, otherwise convert
if command -v magick &> /dev/null; then
    CONVERT_CMD="magick"
else
    CONVERT_CMD="convert"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Generating app icons by resizing original logo..."

# iOS Icons (preserve original aspect ratio)
ios_sizes=(20 29 40 57 60 72 76 83.5 87 120 152 167 180 1024)

for size in "${ios_sizes[@]}"; do
    # Resize while preserving aspect ratio
    $CONVERT_CMD "$LOGO_PATH" -resize "${size}x${size}" -background transparent -gravity center -extent "${size}x${size}" "$OUTPUT_DIR/AppIcon-${size}.png"
    
    # Create @2x and @3x versions where applicable
    if [[ $size == 20 || $size == 29 || $size == 40 || $size == 60 ]]; then
        $CONVERT_CMD "$LOGO_PATH" -resize "$((size*2))x$((size*2))" -background transparent -gravity center -extent "$((size*2))x$((size*2))" "$OUTPUT_DIR/AppIcon-${size}@2x.png"
        $CONVERT_CMD "$LOGO_PATH" -resize "$((size*3))x$((size*3))" -background transparent -gravity center -extent "$((size*3))x$((size*3))" "$OUTPUT_DIR/AppIcon-${size}@3x.png"
    fi
done

# Android Icons (adaptive icon)
android_sizes=(36 48 72 96 144 192 256 384 512)

for size in "${android_sizes[@]}"; do
    # Create foreground for adaptive icon (with padding)
    fg_size=$((size * 8 / 10))  # 80% of size for better visibility
    $CONVERT_CMD "$LOGO_PATH" -resize "${fg_size}x${fg_size}" -background transparent -gravity center -extent "${size}x${size}" "$OUTPUT_DIR/ic_launcher_foreground_${size}.png"
    
    # Create regular launcher icon (circular background)
    $CONVERT_CMD -size "${size}x${size}" xc:"#1e40af" -fill white -draw "circle $((size/2)),$((size/2)) $((size/2)),$((size/3))" "$OUTPUT_DIR/circle_bg_${size}.png"
    logo_size=$((size * 7 / 10))  # 70% for circular icon
    $CONVERT_CMD "$LOGO_PATH" -resize "${logo_size}x${logo_size}" -background transparent -gravity center "$OUTPUT_DIR/logo_resized_${size}.png"
    composite -gravity center "$OUTPUT_DIR/logo_resized_${size}.png" "$OUTPUT_DIR/circle_bg_${size}.png" "$OUTPUT_DIR/ic_launcher_${size}.png"
done

# Create favicon versions (preserve original logo)
$CONVERT_CMD "$LOGO_PATH" -resize 16x16 -background transparent -gravity center -extent 16x16 "$OUTPUT_DIR/favicon-16x16.png"
$CONVERT_CMD "$LOGO_PATH" -resize 32x32 -background transparent -gravity center -extent 32x32 "$OUTPUT_DIR/favicon-32x32.png"
$CONVERT_CMD "$LOGO_PATH" -resize 48x48 -background transparent -gravity center -extent 48x48 "$OUTPUT_DIR/favicon-48x48.png"
$CONVERT_CMD "$LOGO_PATH" -resize 64x64 -background transparent -gravity center -extent 64x64 "$OUTPUT_DIR/favicon-64x64.png"
$CONVERT_CMD "$LOGO_PATH" -resize 128x128 -background transparent -gravity center -extent 128x128 "$OUTPUT_DIR/favicon-128x128.png"
$CONVERT_CMD "$LOGO_PATH" -resize 256x256 -background transparent -gravity center -extent 256x256 "$OUTPUT_DIR/favicon-256x256.png"

# Create ICO file for Windows
$CONVERT_CMD "$OUTPUT_DIR/favicon-16x16.png" "$OUTPUT_DIR/favicon-32x32.png" "$OUTPUT_DIR/favicon-48x48.png" "$OUTPUT_DIR/favicon-256x256.png" "$OUTPUT_DIR/favicon.ico"

# Create additional @2x versions for iOS
$CONVERT_CMD "$LOGO_PATH" -resize 144x144 -background transparent -gravity center -extent 144x144 "$OUTPUT_DIR/AppIcon-72@2x.png"
$CONVERT_CMD "$LOGO_PATH" -resize 152x152 -background transparent -gravity center -extent 152x152 "$OUTPUT_DIR/AppIcon-76@2x.png"
$CONVERT_CMD "$LOGO_PATH" -resize 167x167 -background transparent -gravity center -extent 167x167 "$OUTPUT_DIR/AppIcon-83.5@2x.png"

echo "Icons generated successfully in $OUTPUT_DIR directory"
echo ""
echo "iOS icons to copy to:"
echo "  frontend/ios/App/App/Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "Android icons to copy to:"
echo "  frontend/android/app/src/main/res/mipmap-*dpi/"
echo ""
echo "Web icons to copy to:"
echo "  frontend/public/"

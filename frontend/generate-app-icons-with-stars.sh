#!/bin/bash

# Generate app icons from logo with EU stars above
# This script creates properly sized icons with stars for iOS and Android

LOGO_PATH="src/assets/logo.png"
OUTPUT_DIR="generated-icons"

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null && ! command -v convert &> /dev/null; then
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

echo "Generating app icons with stars from logo..."

# Function to create logo with stars
create_logo_with_stars() {
    local output_size=$1
    local temp_logo="$OUTPUT_DIR/temp_logo_${output_size}.png"
    local temp_stars="$OUTPUT_DIR/temp_stars_${output_size}.png"
    local final_output="$OUTPUT_DIR/logo_with_stars_${output_size}.png"
    
    # Resize original logo to fit (leave space for stars on top)
    local logo_height=$((output_size * 7 / 10))  # 70% for logo
    local stars_height=$((output_size * 3 / 10)) # 30% for stars
    
    # Resize logo
    $CONVERT_CMD "$LOGO_PATH" -resize "x${logo_height}" -background transparent -gravity center -extent "${output_size}x${logo_height}" "$temp_logo"
    
    # Create stars (simple 5-pointed stars in a row)
    local star_size=$((stars_height / 2))
    local stars_width=$((output_size))
    local stars_y_offset=$((logo_height + stars_height / 2))
    
    # Create transparent canvas for stars
    $CONVERT_CMD -size "${stars_width}x${stars_height}" xc:transparent "$temp_stars"
    
    # Add 5 stars in a row
    for i in {0..4}; do
        local star_x=$((stars_width / 6 * (i + 1)))
        local star_y=$((stars_height / 2))
        
        # Create a simple 5-pointed star using SVG
        local svg_star="<svg width='${star_size}' height='${star_size}' xmlns='http://www.w3.org/2000/svg'>
            <polygon points='${star_size/2},0 ${star_size*0.61},${star_size*0.38} ${star_size},${star_size*0.38} ${star_size*0.69},${star_size*0.59} ${star_size*0.8},${star_size} ${star_size/2},${star_size*0.77} ${star_size*0.2},${star_size} ${star_size*0.31},${star_size*0.59} 0,${star_size*0.38} ${star_size*0.39},${star_size*0.38}' 
            fill='#FFD700' stroke='#FFA500' stroke-width='1'/>
        </svg>"
        
        echo "$svg_star" > "$OUTPUT_DIR/star_${i}.svg"
        $CONVERT_CMD "$OUTPUT_DIR/star_${i}.svg" -resize "${star_size}x${star_size}" "$OUTPUT_DIR/star_${i}.png"
        
        # Composite star onto stars canvas
        $CONVERT_CMD "$temp_stars" "$OUTPUT_DIR/star_${i}.png" -geometry "+${star_x}+${star_y}" -composite "$temp_stars"
    done
    
    # Combine logo and stars
    $CONVERT_CMD -size "${output_size}x${output_size}" xc:transparent \
        "$temp_logo" -geometry "+0+0" -composite \
        "$temp_stars" -geometry "+0+${logo_height}" -composite \
        "$final_output"
    
    # Clean up temp files
    rm -f "$temp_logo" "$temp_stars" "$OUTPUT_DIR"/star_*.svg "$OUTPUT_DIR"/star_*.png
    
    echo "$final_output"
}

# iOS Icons (square with rounded corners)
ios_sizes=(20 29 40 57 60 72 76 83.5 87 120 152 167 180 1024)

for size in "${ios_sizes[@]}"; do
    # Create logo with stars
    logo_with_stars=$(create_logo_with_stars $size)
    
    # Create square version
    $CONVERT_CMD "$logo_with_stars" -background transparent -gravity center -extent "${size}x${size}" "$OUTPUT_DIR/AppIcon-${size}.png"
    
    # Create @2x and @3x versions where applicable
    if [[ $size == 20 || $size == 29 || $size == 40 || $size == 60 ]]; then
        logo_with_stars_2x=$(create_logo_with_stars $((size*2)))
        $CONVERT_CMD "$logo_with_stars_2x" -background transparent -gravity center -extent "$((size*2))x$((size*2))" "$OUTPUT_DIR/AppIcon-${size}@2x.png"
        
        logo_with_stars_3x=$(create_logo_with_stars $((size*3)))
        $CONVERT_CMD "$logo_with_stars_3x" -background transparent -gravity center -extent "$((size*3))x$((size*3))" "$OUTPUT_DIR/AppIcon-${size}@3x.png"
    fi
done

# Android Icons (adaptive icon)
android_sizes=(36 48 72 96 144 192 256 384 512)

for size in "${android_sizes[@]}"; do
    # Create logo with stars
    logo_with_stars=$(create_logo_with_stars $size)
    
    # Create foreground for adaptive icon (with padding)
    fg_size=$((size * 7 / 10))
    $CONVERT_CMD "$logo_with_stars" -resize "${fg_size}x${fg_size}" -background transparent -gravity center -extent "${size}x${size}" "$OUTPUT_DIR/ic_launcher_foreground_${size}.png"
    
    # Create regular launcher icon (circular background)
    $CONVERT_CMD -size "${size}x${size}" xc:"#1e40af" -fill white -draw "circle $((size/2)),$((size/2)) $((size/2)),$((size/3))" "$OUTPUT_DIR/circle_bg_${size}.png"
    logo_size=$((size * 6 / 10))
    $CONVERT_CMD "$logo_with_stars" -resize "${logo_size}x${logo_size}" -background transparent -gravity center "$OUTPUT_DIR/logo_resized_${size}.png"
    composite -gravity center "$OUTPUT_DIR/logo_resized_${size}.png" "$OUTPUT_DIR/circle_bg_${size}.png" "$OUTPUT_DIR/ic_launcher_${size}.png"
done

# Create favicon versions
favicon_with_stars=$(create_logo_with_stars 256)
$CONVERT_CMD "$favicon_with_stars" -resize 16x16 -background transparent -gravity center -extent 16x16 "$OUTPUT_DIR/favicon-16x16.png"
$CONVERT_CMD "$favicon_with_stars" -resize 32x32 -background transparent -gravity center -extent 32x32 "$OUTPUT_DIR/favicon-32x32.png"
$CONVERT_CMD "$favicon_with_stars" -resize 48x48 -background transparent -gravity center -extent 48x48 "$OUTPUT_DIR/favicon-48x48.png"
$CONVERT_CMD "$favicon_with_stars" -resize 64x64 -background transparent -gravity center -extent 64x64 "$OUTPUT_DIR/favicon-64x64.png"
$CONVERT_CMD "$favicon_with_stars" -resize 128x128 -background transparent -gravity center -extent 128x128 "$OUTPUT_DIR/favicon-128x128.png"
$CONVERT_CMD "$favicon_with_stars" -resize 256x256 -background transparent -gravity center -extent 256x256 "$OUTPUT_DIR/favicon-256x256.png"

# Create ICO file for Windows
$CONVERT_CMD "$OUTPUT_DIR/favicon-16x16.png" "$OUTPUT_DIR/favicon-32x32.png" "$OUTPUT_DIR/favicon-48x48.png" "$OUTPUT_DIR/favicon-256x256.png" "$OUTPUT_DIR/favicon.ico"

# Create additional @2x versions for iOS
logo_with_stars_144=$(create_logo_with_stars 144)
$CONVERT_CMD "$logo_with_stars_144" -background transparent -gravity center -extent 144x144 "$OUTPUT_DIR/AppIcon-72@2x.png"

logo_with_stars_152=$(create_logo_with_stars 152)
$CONVERT_CMD "$logo_with_stars_152" -background transparent -gravity center -extent 152x152 "$OUTPUT_DIR/AppIcon-76@2x.png"

logo_with_stars_167=$(create_logo_with_stars 167)
$CONVERT_CMD "$logo_with_stars_167" -background transparent -gravity center -extent 167x167 "$OUTPUT_DIR/AppIcon-83.5@2x.png"

# Clean up remaining temp files
rm -f "$OUTPUT_DIR"/logo_with_stars_*.png

echo "Icons with stars generated successfully in $OUTPUT_DIR directory"
echo ""
echo "iOS icons to copy to:"
echo "  frontend/ios/App/App/Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "Android icons to copy to:"
echo "  frontend/android/app/src/main/res/mipmap-*dpi/"
echo ""
echo "Web icons to copy to:"
echo "  frontend/public/"

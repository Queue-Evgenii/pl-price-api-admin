#!/bin/bash

# Simple script to create logo with stars using ImageMagick primitives
# This creates a logo with EU-style stars above the Polish flag

LOGO_PATH="src/assets/logo.png"
OUTPUT_PATH="src/assets/logo-with-stars.png"

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

echo "Creating logo with stars..."

# Create a larger canvas (300x200) to accommodate stars
$CONVERT_CMD -size 300x200 xc:transparent temp_canvas.png

# Place the original logo at the bottom (200x151 size, positioned at y=49)
$CONVERT_CMD "$LOGO_PATH" -geometry +0+49 temp_logo.png

# Create 5 golden stars above the logo
# Star positions: spread across the top area
star_positions=("50,25" "100,15" "150,15" "200,15" "250,25")

for pos in "${star_positions[@]}"; do
    # Create a simple star using ImageMagick drawing primitives
    $CONVERT_CMD -size 30x30 xc:transparent -fill gold -stroke orange -strokewidth 1 \
        -draw "polygon 15,2 19,11 28,11 21,17 24,26 15,20 6,26 9,17 2,11 11,11" \
        temp_star.png
    
    # Position the star
    $CONVERT_CMD temp_canvas.png temp_star.png -geometry "+${pos%,*}+${pos#*,}" -composite temp_canvas.png
done

# Combine everything
$CONVERT_CMD temp_canvas.png temp_logo.png -composite "$OUTPUT_PATH"

# Clean up
rm -f temp_canvas.png temp_logo.png temp_star.png

echo "Logo with stars created: $OUTPUT_PATH"
echo ""
echo "You can now use this logo with the original icon generation script:"
echo "./generate-app-icons.sh"
echo ""
echo "Just update the LOGO_PATH variable in generate-app-icons.sh to point to:"
echo "src/assets/logo-with-stars.png"

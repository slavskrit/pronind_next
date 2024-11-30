#!/bin/bash

# Input directory for images
IMAGE_DIR="${1:-gallery/sources}"
# Output directory for WebP images
OUTPUT_DIR="${2:-gallery/optimized}"
# Output file for generated HTML
OUTPUT_FILE="${3:-gallery/index.html}"

# Ensure the output directories exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Dependencies: Ensure `imagemagick` and `cwebp` are installed
if ! command -v convert &>/dev/null || ! command -v cwebp &>/dev/null; then
  echo "Error: imagemagick and cwebp are required. Please install them."
  exit 1
fi

# Start writing the HTML structure
cat <<EOF >"$OUTPUT_FILE"
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="main.css">
    <title>Gallery</title>
  </head>
  <body>
    <div class="container">
EOF

# Process each image in the directory
if [ -d "$IMAGE_DIR" ]; then
  count=1
  for img in "$IMAGE_DIR"/*.{jpg,jpeg,png,gif}; do
    if [ -f "$img" ]; then
      # Get the base name without extension
      base_name=$(basename "$img" | sed 's/\.[^.]*$//')

      # Define output paths for small and full images
      small_img="${OUTPUT_DIR}/${base_name}_small.webp"
      full_img="${OUTPUT_DIR}/${base_name}_full.webp"

      # Convert to WebP and resize
      echo "Processing $img..."
      convert "$img" -resize 400x400 -quality 80 "$small_img"    # Small image
      convert "$img" -resize 1200x1200\> -quality 90 "$full_img" # Full image

      # Adjust paths to be relative to the `gallery` directory
      small_img_path="optimized/${base_name}_small.webp"
      full_img_path="optimized/${base_name}_full.webp"

      # Append image and caption to the HTML
      cat <<EOF >>"$OUTPUT_FILE"
      <a href="$full_img_path"><img src="$small_img_path" loading="lazy"/></a>
EOF
      ((count++))
    fi
  done
else
  echo "Directory $IMAGE_DIR does not exist."
fi

# Close the HTML structure
cat <<EOF >>"$OUTPUT_FILE"
    </div>
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-CRV83TDMN5"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-CRV83TDMN5');
    </script>
  </body>
</html>
EOF

echo "HTML gallery generated at $OUTPUT_FILE"
echo "Optimized images saved to $OUTPUT_DIR"

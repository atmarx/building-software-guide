#!/bin/bash

# Convert PNG images to WebP format
# Requires: cwebp (Arch: extra/libwebp-utils)
# Source: /assets/images/*.png
# Destination: /docs/assets/images/*.webp

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/assets/images"
DEST_DIR="$SCRIPT_DIR/docs/assets/images"
QUALITY=85

convert_file() {
    local name="$1"
    local src="$SRC_DIR/${name}.png"
    local dest="$DEST_DIR/${name}.webp"

    if [[ ! -f "$src" ]]; then
        echo "Error: $src not found"
        return 1
    fi

    echo "Converting: $name.png → $name.webp"
    cwebp -q "$QUALITY" "$src" -o "$dest"

    if [[ $? -eq 0 ]]; then
        local src_size=$(du -h "$src" | cut -f1)
        local dest_size=$(du -h "$dest" | cut -f1)
        echo "  Done: $src_size → $dest_size"
    fi
}

show_usage() {
    echo "Usage: $0 [filename|--all]"
    echo ""
    echo "Convert PNG images from /assets/images to WebP in /docs/assets/images"
    echo ""
    echo "Options:"
    echo "  filename    Convert a single file (without extension)"
    echo "              Example: $0 lessons-learned"
    echo ""
    echo "  --all       Convert all PNG files found in source directory"
    echo ""
    echo "Available files:"
    for f in "$SRC_DIR"/*.png; do
        if [[ -f "$f" ]]; then
            basename "$f" .png
        fi
    done
}

# Main
if [[ $# -eq 0 ]]; then
    show_usage
    exit 0
fi

if [[ "$1" == "--all" ]]; then
    echo "Converting all PNG files..."
    echo ""
    for f in "$SRC_DIR"/*.png; do
        if [[ -f "$f" ]]; then
            name=$(basename "$f" .png)
            convert_file "$name"
            echo ""
        fi
    done
    echo "Done!"
else
    convert_file "$1"
fi

#!/bin/bash
# zig/concat.sh - Simple concat using marker

# set -e

OUTPUT="gemm.zig"
SRC_DIR="src"

cat > "$OUTPUT" << 'EOF'
// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {
EOF

shopt -s nullglob
found=0

for dir in "$SRC_DIR"/*/; do
    if [ -d "$dir" ]; then
        module=$(basename "$dir")
        file="$dir${module}.zig"
        
        if [ -f "$file" ]; then
            echo "" >> "$OUTPUT"
            echo "// --- FROM $module/$module.zig ---" >> "$OUTPUT"
            
            # Take only lines AFTER the marker
            # sed -n '/\/\/-concat marker/,$ p' "$file" >> "$OUTPUT"
            awk '/\/\/-concat marker/ { flag=1; next } flag' "$file" >> "$OUTPUT"
            
            echo "" >> "$OUTPUT"
            echo "" >> "$OUTPUT"
            echo "✓ Added: $module" >&2
            ((found++))
        else
            echo "⚠ Warning: $module.zig not found" >&2
        fi
    fi
done

echo "};" >> "$OUTPUT"

echo "gemm.zig generated successfully! ($found modules)"
exit 0
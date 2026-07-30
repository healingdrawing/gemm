#!/bin/bash
set -e

echo "Generating gemm.zig..."
./concat.sh

echo "Running tests..."
DEVLOG=true zig run test.zig

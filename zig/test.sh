#!/bin/bash
set -e

echo "Generating gemm.zig..."
./concat.sh

echo "Running tests..."
zig run test.zig

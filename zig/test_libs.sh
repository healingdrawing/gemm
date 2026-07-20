#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "=== Building libraries ==="
zig build -Doptimize=ReleaseFast

echo "=== Testing libgemm.a (native) ==="
zig build-exe test_libs.zig -L ./zig-out/lib -l gemm --name test_native
./test_native

echo "=== WASM library status ==="
ls -lh zig-out/lib/libgemm_wasm.a

echo "=== All done ==="
#!/usr/bin/env bash
set -euo pipefail

# number of runs (default 11)
runs=${1:-11}

# find first file that starts with "bench_" and ends with ".zig"
bench_file=$(ls bench_*.zig 2>/dev/null | head -n 1)

if [[ -z "$bench_file" ]]; then
    echo "No file matching 'bench_*.zig' found in $(pwd)"
    exit 1
fi

echo "=== Running $bench_file  ${runs} times ==="
echo

for i in $(seq 1 "$runs"); do
    echo "----- run $i / $runs -----"
    zig run "$bench_file" -OReleaseFast
    echo
done

echo "=== done ==="
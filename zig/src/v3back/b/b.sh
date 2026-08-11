#!/usr/bin/env bash
set -euo pipefail

# remove old outputs
rm -f _*

# number of runs (default 22 executions , minus 2 egde case, so 20. 50+ was too long)
runs=${1:-22}

# find one folder up the first file that starts with "bench_" and ends with ".zig"
bench_file=$(ls ../bench_*.zig 2>/dev/null | head -n 1)

if [[ -z "$bench_file" ]]; then
    echo "No file matching 'bench_*.zig' found in $(pwd)"
    exit 1
fi

echo "=== Running $bench_file  ${runs} times ==="
echo

# wall-clock start of the whole session
start_ns=$(date +%s%N)

for i in $(seq 1 "$runs"); do
    echo "----- run $i / $runs -----"
    zig run "$bench_file" -OReleaseFast
    echo
done

# wall-clock end
end_ns=$(date +%s%N)
elapsed_ns=$((end_ns - start_ns))

# show elapsed for information
elapsed_s=$((elapsed_ns / 1000000000))
elapsed_m=$((elapsed_s / 60))

echo "Total wall time: ${elapsed_s} seconds or about ${elapsed_m} minutes"
echo "=== done ==="
echo
echo "=== analyze ==="
zig run report.zig
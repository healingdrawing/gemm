#!/usr/bin/env bash
set -euo pipefail

# remove old outputs
rm -f _*

# number of runs (default 58 executions , minus 8 egde case in report.zig, so stats for 50)
runs=${1:-58}

# find one folder up the first file that starts with "bench_" and ends with ".zig"
bench_file=$(ls ../bench_*.zig 2>/dev/null | head -n 1)

if [[ -z "$bench_file" ]]; then
    echo "No file matching 'bench_*.zig' found in $(pwd)"
    exit 1
fi

echo "=== Running $bench_file  ${runs} times ==="
echo

# ------------------------------------------------------------------
# Cycle through the last four cores for better stability measurement
# Example (8 cores): 4 5 6 7 4 5 6 7 4 5 ...
# ------------------------------------------------------------------
ISOLATE=1   # set to 0 to disable isolation

if [[ $ISOLATE -eq 1 ]]; then
    NCORES=$(nproc)

    if (( NCORES < 4 )); then
        echo "Warning: less than 4 cores detected ($NCORES). Using core 0 only."
        LAST4=(0)
    else
        FIRST_OF_LAST4=$((NCORES - 4))
        LAST4=()
        for ((c = FIRST_OF_LAST4; c < NCORES; c++)); do
            LAST4+=("$c")
        done
    fi

    echo "Will cycle through quiet cores: ${LAST4[*]}"
else
    LAST4=()   # unused
fi

# wall-clock start of the whole session
start_ns=$(date +%s%N)

for i in $(seq 1 "$runs"); do
    echo "----- run $i / $runs -----"

    if [[ $ISOLATE -eq 1 ]]; then
        # pick next core in round-robin fashion
        CORE=${LAST4[$(( (i - 1) % ${#LAST4[@]} ))]}

        # IRQ mask = all cores except the chosen one
        IRQ_MASK=$(printf '%x' $(( (1 << NCORES) - 1 - (1 << CORE) )))

        sudo bash -c "
            for irq in /proc/irq/[0-9]*; do
                [ -f \"\$irq/smp_affinity\" ] || continue
                echo $IRQ_MASK > \"\$irq/smp_affinity\" 2>/dev/null || true
            done
            echo $IRQ_MASK > /proc/irq/default_smp_affinity
        " >/dev/null

        TASKSET="taskset -c $CORE"
        echo "  (bound to core $CORE)"
    else
        TASKSET=""
    fi

    $TASKSET zig run "$bench_file" -OReleaseFast
    echo
done

# wall-clock end
end_ns=$(date +%s%N)
elapsed_ns=$((end_ns - start_ns))

# show elapsed for information
elapsed_s=$((elapsed_ns / 1000000000))
elapsed_m=$((elapsed_s / 60))

# Restore normal IRQ affinity
if [[ $ISOLATE -eq 1 ]]; then
    echo "Restoring normal IRQ affinity ..."
    FULL_MASK=$(printf '%x' $(( (1 << NCORES) - 1 )))
    sudo bash -c "echo $FULL_MASK > /proc/irq/default_smp_affinity"
fi

echo "=== done ==="
echo "Total wall time: ${elapsed_s} seconds or about ${elapsed_m} minutes"
echo

echo "=== analyze ==="
zig run report.zig
#!/usr/bin/env bash
# set -euo pipefail
set -eo pipefail

method=${1}

# number of runs (default 11 in b.sh)
runs=${2}

if [ -z "$method" ]; then
    echo "Usage: ./bench.sh <method> [runs]"
    echo "  method: method name from 'src' folder (e.g., v3back, v3mag2)"
    echo "  runs:   number of benchmark executions (default set in b.sh: 11)"
    exit 1
fi


# echo "path: src/$method/b/b.sh"
cd "src/$method/b"

./b.sh "$runs" "$method" || {
    echo "b.sh failed with exit code $?"
    echo "Usage: b.sh <runs> <method>"
    echo "  runs:   number of benchmark iterations (default: 11)"
    echo "  method: method name (e.g., v3back, v3mag2)"
    exit 1
}

# Decided to avoid any benchmarks.

## Results affected by noise, two ways tested, always mess.

For example of multi rerun to confirm fail, the next methods have artificial bench implementations(different approaches):
- zig/src/v3back/bench_v3back.zig
- zig/src/v3back/b
- zig/src/v3one/bench_v3one.zig
- zig/src/v3one/b
- bench.sh

Do not waste more time for this shit.
Just write clear code with isolated const when used 3+ times in code
Also follow approach in:
- func-performance.md
- rawformat.txt

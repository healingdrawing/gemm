wip

# zig 0.16 based implementation of gemm

## Development environment
- **zig** (zig language vscode extension from ziglang.org used in dev process)
- **bun runtime** (version 1.3.13 was installed in the system in dev process)

terminal: `./test.sh`

Execute from inside **zig** folder, to reconcat **gemm.zig** file and then run tests in terminal

Tests compare **gemm.zig** (transcoded) vs **gemm.ts** (battle tested) results.

## Artefacts

The **bench.sh** is artificial bench executor, implemented only for v3back, v3one, and finally not developed based on useless results of these two (different approach based) implementations.

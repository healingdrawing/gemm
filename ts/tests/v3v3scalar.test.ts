// @ts-nocheck
// v3v3scalar.test.ts
import { describe, it, expect } from "bun:test";
import { GEMM } from "../gemm";
import { readFileSync } from "fs";
import { resolve } from "path";

describe("v3v3scalar", () => {
  it("should produce identical results between TS and Zig implementations", async () => {
    // Load WASM
    const wasmPath = resolve(__dirname, "../../zig/zig-out/bin/gemm.wasm");
    const wasmBuffer = readFileSync(wasmPath);
    const wasmModule = await WebAssembly.instantiate(wasmBuffer);
    const wasm = wasmModule.instance.exports;

    // Test data
    const v3a = new Float32Array([1.0, 2.0, 3.0]);
    const v3b = new Float32Array([4.0, 5.0, 6.0]);

    // TS implementation
    const gemm = new GEMM();
    const tsResult = gemm.v3v3scalar(v3a, v3b);

    // Zig implementation via WASM
    const zigResult = (wasm.v3v3scalar_wasm as CallableFunction)(
      v3a.byteOffset,
      v3b.byteOffset
    );

    expect(tsResult).toBe(zigResult);
  });
});

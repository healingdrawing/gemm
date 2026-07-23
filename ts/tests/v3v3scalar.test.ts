// @ts-nocheck
// v3v3scalar.test.ts
import { describe, it, expect } from "bun:test";
import { GEMM } from "../gemm";

const CLI_V3V3SCALAR = "../../zig/src/v3v3scalar/zig-out/bin/cli_v3v3scalar";

async function callCliV3V3Scalar(ax: number, ay: number, az: number, bx: number, by: number, bz: number): Promise<number> {
  const proc = Bun.spawn([
    CLI_V3V3SCALAR,
    ax.toString(), ay.toString(), az.toString(),
    bx.toString(), by.toString(), bz.toString()
  ], {
    stdout: "pipe",   // important
    stderr: "pipe",
  });

  const output = await proc.stdout.text();
  const result = parseFloat(output.trim());

  if (isNaN(result)) {
    const err = await proc.stderr.text();
    throw new Error(`CLI failed. Stdout: "${output.trim()}" Stderr: "${err.trim()}"`);
  }

  await proc.exited; // wait for process to finish

  return result;
}

describe("v3v3scalar", () => {
  const gemm = new GEMM();

  it("TS implementation (reference)", () => {
    const result = gemm.v3v3scalar(new Float32Array([1, 2, 3]), new Float32Array([4, 5, 6]));
    expect(result).toBe(32);
  });

  it("CLI matches TS implementation", async () => {
    const tsResult = gemm.v3v3scalar(new Float32Array([1, 2, 3]), new Float32Array([4, 5, 6]));
    const cliResult = await callCliV3V3Scalar(1, 2, 3, 4, 5, 6);

    expect(tsResult).toBeCloseTo(cliResult, 6);
  });
});
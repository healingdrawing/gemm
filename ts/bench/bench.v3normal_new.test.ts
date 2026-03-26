// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

describe("v3normal vs vec3Dnormal", () => {
  const v3a = new Float32Array([1, 0, 0]);
  const v3b = new Float32Array([0, 1, 0]);
  const v3n = new Float32Array(3);
  const arrA = [1, 0, 0];
  const arrB = [0, 1, 0];

  test("benchmark cross product 10000 runs", () => {
    const start1 = performance.now();
    for (let i = 0; i < 10000; i++) {
      gemm.v3normal_new(v3a, v3b);
    }
    const time1 = performance.now() - start1;

    const start2 = performance.now();
    for (let i = 0; i < 10000; i++) {
      gemm.v3normal(v3a, v3b, v3n);   // pure in-place, no extra allocation
    }
    const time2 = performance.now() - start2;

    console.log(`v3normal_new 10000 runs: ${time1.toFixed(2)} ms`);
    console.log(`v3normal    10000 runs: ${time2.toFixed(2)} ms`);
  });
});
// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

describe("v3one vs vecXDone", () => {
  const v3 = new Float32Array([1, 2, 3]);
  const arr = [1, 2, 3];
  const v3copy = new Float32Array(3); // pre-allocated

  describe("Accuracy comparison", () => {
    test("results should be similar", () => {
      const oldResult = gemm.vecXDone(arr);
      v3copy.set(v3);
      gemm.v3one(v3copy);
      expect(v3copy[0]).toBeCloseTo(oldResult[0], 6);
      expect(v3copy[1]).toBeCloseTo(oldResult[1], 6);
      expect(v3copy[2]).toBeCloseTo(oldResult[2], 6);
    });
  });

  describe("Benchmark 10000 runs", () => {
    test("normalize performance", () => {
      const start1 = performance.now();
      for (let i = 0; i < 10000; i++) {
        gemm.vecXDone(arr);
      }
      const time1 = performance.now() - start1;

      const start2 = performance.now();
      for (let i = 0; i < 10000; i++) {
        v3copy.set(v3);        // fast copy
        gemm.v3one(v3copy);
      }
      const time2 = performance.now() - start2;

      console.log(`vecXDone   10000 runs: ${time1.toFixed(2)} ms`);
      console.log(`v3one      10000 runs: ${time2.toFixed(2)} ms`);
    });
  });
});
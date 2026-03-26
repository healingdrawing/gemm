// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

describe("v3v3cos vs vecXDcos", () => {
  describe("Accuracy comparison", () => {
    test("orthogonal vectors [1,0,0] [0,1,0]", () => {
      const oldResult = gemm.vecXDcos([1,0,0], [0,1,0]);
      const newResult = gemm.v3v3cos(new Float32Array([1,0,0]), new Float32Array([0,1,0]));
      expect(newResult).toBeCloseTo(oldResult, 6);
    });

    test("vectors [1,2,3] [4,5,6]", () => {
      const oldResult = gemm.vecXDcos([1,2,3], [4,5,6]);
      const newResult = gemm.v3v3cos(new Float32Array([1,2,3]), new Float32Array([4,5,6]));
      expect(newResult).toBeCloseTo(oldResult, 6);
    });

    test("parallel vectors [1,1,1] [1,1,1]", () => {
      const oldResult = gemm.vecXDcos([1,1,1], [1,1,1]);
      const newResult = gemm.v3v3cos(new Float32Array([1,1,1]), new Float32Array([1,1,1]));
      expect(newResult).toBeCloseTo(oldResult, 6);
    });

    test("opposite direction [-1,2,-3] [4,-5,6]", () => {
      const oldResult = gemm.vecXDcos([-1,2,-3], [4,-5,6]);
      const newResult = gemm.v3v3cos(new Float32Array([-1,2,-3]), new Float32Array([4,-5,6]));
      expect(newResult).toBeCloseTo(oldResult, 6);
    });

    test("zero vector case [0,0,0] [1,2,3]", () => {
      const oldResult = gemm.vecXDcos([0,0,0], [1,2,3]);
      const newResult = gemm.v3v3cos(new Float32Array([0,0,0]), new Float32Array([1,2,3]));
      expect(newResult).toBe(NaN);
      expect(oldResult).toBe(0);
    });
  });

  describe("Benchmark 10000 runs", () => {
    test("cosine performance", () => {
      const v3a = new Float32Array([1, 2, 3]);
      const v3b = new Float32Array([4, 5, 6]);
      const arrA = [1, 2, 3];
      const arrB = [4, 5, 6];

      const start1 = performance.now();
      for (let i = 0; i < 10000; i++) {
        gemm.vecXDcos(arrA, arrB);
      }
      const time1 = performance.now() - start1;

      const start2 = performance.now();
      for (let i = 0; i < 10000; i++) {
        gemm.v3v3cos(v3a, v3b);
      }
      const time2 = performance.now() - start2;

      console.log(`vecXDcos (old) 10000 runs: ${time1.toFixed(2)} ms`);
      console.log(`v3v3cos (new)  10000 runs: ${time2.toFixed(2)} ms`);
    });
  });
});

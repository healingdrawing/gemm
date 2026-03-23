// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3norm2 function using Bun's built-in test runner
 * Tests squared vector length calculation (magnitude squared) for 3D vectors
 * Useful for fast non-zero checks without expensive sqrt operation
 */

describe("v3norm2", () => {
  describe("Basic squared norm calculation", () => {
    test("should calculate squared norm for [1,2,3]", () => {
      const vec = new Float32Array([1, 2, 3]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(14); // 1 + 4 + 9
    });

    test("should calculate squared norm for [2,3,6]", () => {
      const vec = new Float32Array([2, 3, 6]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(49); // 4 + 9 + 36
    });

    test("should calculate squared norm for [1,1,1]", () => {
      const vec = new Float32Array([1, 1, 1]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(3); // 1 + 1 + 1
    });

    test("should calculate squared norm for [3,4,0]", () => {
      const vec = new Float32Array([3, 4, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(25); // 9 + 16 + 0
    });

    test("should calculate squared norm for [5,12,0]", () => {
      const vec = new Float32Array([5, 12, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(169); // 25 + 144 + 0
    });
  });

  describe("Zero and unit vectors", () => {
    test("should return 0 for zero vector [0,0,0]", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(0);
    });

    test("should return 1 for unit vector [1,0,0]", () => {
      const vec = new Float32Array([1, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for unit vector [0,1,0]", () => {
      const vec = new Float32Array([0, 1, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for unit vector [0,0,1]", () => {
      const vec = new Float32Array([0, 0, 1]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(1);
    });
  });

  describe("Negative values", () => {
    test("should handle negative components [-1,-2,-3]", () => {
      const vec = new Float32Array([-1, -2, -3]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(14); // 1 + 4 + 9 (negatives squared become positive)
    });

    test("should handle mixed signs [-3,4,0]", () => {
      const vec = new Float32Array([-3, 4, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(25); // 9 + 16 + 0
    });
  });

  describe("Large values", () => {
    test("should calculate squared norm for large values [100,200,300]", () => {
      const vec = new Float32Array([100, 200, 300]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(140000); // 10000 + 40000 + 90000
    });
  });

  describe("Fractional values", () => {
    test("should calculate squared norm for [0.5,0.5,0.5]", () => {
      const vec = new Float32Array([0.5, 0.5, 0.5]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(0.75); // 0.25 + 0.25 + 0.25
    });

    test("should calculate squared norm for [1/3, 1/3, 1/3]", () => {
      const vec = new Float32Array([1/3, 1/3, 1/3]);
      const result = gemm.v3mag2(vec);
      expect(result).toBeCloseTo(1/3); // (1/9) + (1/9) + (1/9)
    });
  });

  describe("Fail cases - NaN handling", () => {
    test("should return NaN when vector contains NaN [NaN,0,0]", () => {
      const vec = new Float32Array([NaN, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(0);
    });

    test("should return NaN when vector contains NaN [1,NaN,3]", () => {
      const vec = new Float32Array([1, NaN, 3]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(0);
    });

    test("should return NaN when all components are NaN [NaN,NaN,NaN]", () => {
      const vec = new Float32Array([NaN, NaN, NaN]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(0);
    });
  });

  describe("Fail cases - Infinity handling", () => {
    test("should return Infinity when vector contains Infinity [Infinity,0,0]", () => {
      const vec = new Float32Array([Infinity, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(Infinity);
    });

    test("should return Infinity when vector contains Infinity [1,2,Infinity]", () => {
      const vec = new Float32Array([1, 2, Infinity]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(Infinity);
    });

    test("should return Infinity when vector contains negative Infinity [-Infinity,0,0]", () => {
      const vec = new Float32Array([-Infinity, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(Infinity);
    });

    test("should return Infinity when all components are Infinity [Infinity,Infinity,Infinity]", () => {
      const vec = new Float32Array([Infinity, Infinity, Infinity]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(Infinity);
    });

    test("should return 0 when mixing positive and negative Infinity [Infinity,-Infinity,0]", () => {
      const vec = new Float32Array([Infinity, -Infinity, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(Number.POSITIVE_INFINITY);
    });
  });

  describe("Edge cases - zero return behavior", () => {
    test("should return 0 (not undefined or null) for zero vector", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(result).toBe(0);
      expect(typeof result).toBe("number");
    });

    test("should return 0 as falsy value for zero vector", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3mag2(vec);
      expect(!result).toBe(true);
    });

    test("should distinguish between 0 and very small positive number", () => {
      const vec1 = new Float32Array([0, 0, 0]);
      const vec2 = new Float32Array([0.0001, 0.0001, 0.0001]);
      const result1 = gemm.v3mag2(vec1);
      const result2 = gemm.v3mag2(vec2);
      expect(result1).toBe(0);
      expect(result2).toBeGreaterThan(0);
    });
  });

});

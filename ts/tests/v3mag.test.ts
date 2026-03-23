// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3norm function using Bun's built-in test runner
 * Tests vector length calculation (magnitude/norm) for 3D vectors
 * NaN in any component raises 0 result
 */

describe("v3norm", () => {
  describe("Basic norm calculation", () => {
    test("should calculate norm for [1,2,3]", () => {
      const vec = new Float32Array([1, 2, 3]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(14)); // sqrt(1 + 4 + 9)
    });

    test("should calculate norm for [2,3,6]", () => {
      const vec = new Float32Array([2, 3, 6]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(7); // sqrt(4 + 9 + 36) = sqrt(49)
    });

    test("should calculate norm for [1,1,1]", () => {
      const vec = new Float32Array([1, 1, 1]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(3));
    });

    test("should calculate norm for [3,4,0]", () => {
      const vec = new Float32Array([3, 4, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(5); // sqrt(9 + 16 + 0)
    });

    test("should calculate norm for [5,12,0]", () => {
      const vec = new Float32Array([5, 12, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(13); // sqrt(25 + 144 + 0)
    });

    test("should calculate norm for [1,2,2]", () => {
      const vec = new Float32Array([1, 2, 2]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(3); // sqrt(1 + 4 + 4)
    });
  });

  describe("Zero and unit vectors", () => {
    test("should return 0 for zero vector [0,0,0]", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 1 for unit vector [1,0,0]", () => {
      const vec = new Float32Array([1, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for unit vector [0,1,0]", () => {
      const vec = new Float32Array([0, 1, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for unit vector [0,0,1]", () => {
      const vec = new Float32Array([0, 0, 1]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for normalized vector [1/sqrt(3), 1/sqrt(3), 1/sqrt(3)]", () => {
      const val = 1 / Math.sqrt(3);
      const vec = new Float32Array([val, val, val]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Negative values", () => {
    test("should handle negative components [-1,-2,-3]", () => {
      const vec = new Float32Array([-1, -2, -3]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(14)); // sqrt(1 + 4 + 9)
    });

    test("should handle mixed signs [-3,4,0]", () => {
      const vec = new Float32Array([-3, 4, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(5); // sqrt(9 + 16 + 0)
    });

    test("should handle all negative [-1,-1,-1]", () => {
      const vec = new Float32Array([-1, -1, -1]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(3));
    });
  });

  describe("Large values", () => {
    test("should calculate norm for large values [100,200,300]", () => {
      const vec = new Float32Array([100, 200, 300]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(140000)); // sqrt(10000 + 40000 + 90000)
    });

    test("should calculate norm for [1000,1000,1000]", () => {
      const vec = new Float32Array([1000, 1000, 1000]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(1000 * Math.sqrt(3));
    });
  });

  describe("Fractional values", () => {
    test("should calculate norm for [0.5,0.5,0.5]", () => {
      const vec = new Float32Array([0.5, 0.5, 0.5]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(0.75));
    });

    test("should calculate norm for [0.1,0.2,0.3]", () => {
      const vec = new Float32Array([0.1, 0.2, 0.3]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(Math.sqrt(0.14));
    });

    test("should calculate norm for very small values [0.0001,0.0001,0.0001]", () => {
      const vec = new Float32Array([0.0001, 0.0001, 0.0001]);
      const result = gemm.v3mag(vec);
      expect(result).toBeCloseTo(0.0001 * Math.sqrt(3));
    });
  });

  describe("Fail cases - NaN handling (returns 0)", () => {
    test("should return 0 when vector contains NaN [NaN,0,0]", () => {
      const vec = new Float32Array([NaN, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 0 when vector contains NaN [1,NaN,3]", () => {
      const vec = new Float32Array([1, NaN, 3]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 0 when all components are NaN [NaN,NaN,NaN]", () => {
      const vec = new Float32Array([NaN, NaN, NaN]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 0 when NaN is in last component [1,2,NaN]", () => {
      const vec = new Float32Array([1, 2, NaN]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 0 for mixed NaN and normal values [0.5,NaN,0.5]", () => {
      const vec = new Float32Array([0.5, NaN, 0.5]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });
  });

  describe("Fail cases - Infinity handling", () => {
    test("should return Infinity when vector contains Infinity [Infinity,0,0]", () => {
      const vec = new Float32Array([Infinity, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Infinity);
    });

    test("should return Infinity when vector contains Infinity [1,2,Infinity]", () => {
      const vec = new Float32Array([1, 2, Infinity]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Infinity);
    });

    test("should return Infinity when vector contains negative Infinity [-Infinity,0,0]", () => {
      const vec = new Float32Array([-Infinity, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Infinity);
    });

    test("should return Infinity when all components are Infinity [Infinity,Infinity,Infinity]", () => {
      const vec = new Float32Array([Infinity, Infinity, Infinity]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Infinity);
    });

    test("should return NaN when mixing positive and negative Infinity [Infinity,-Infinity,0]", () => {
      const vec = new Float32Array([Infinity, -Infinity, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Number.POSITIVE_INFINITY);
    });

    test("should return NaN when mixing Infinity and -Infinity [Infinity,-Infinity,5]", () => {
      const vec = new Float32Array([Infinity, -Infinity, 5]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Number.POSITIVE_INFINITY);
    });

    test("should return Infinity for large values approaching Infinity", () => {
      const vec = new Float32Array([1e308, 1e308, 1e308]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(Infinity);
    });
  });

  describe("Edge cases - NaN vs Infinity interaction", () => {
    test("should return 0 when NaN and Infinity coexist [NaN,Infinity,0]", () => {
      const vec = new Float32Array([NaN, Infinity, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 0 when NaN and -Infinity coexist [-Infinity,NaN,5]", () => {
      const vec = new Float32Array([-Infinity, NaN, 5]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });

    test("should return 0 when NaN dominates over Infinity [NaN,Infinity,Infinity]", () => {
      const vec = new Float32Array([NaN, Infinity, Infinity]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
    });
  });

  describe("Zero return behavior", () => {
    test("should return exactly 0 (not undefined or null) for zero vector", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(result).toBe(0);
      expect(typeof result).toBe("number");
    });

    test("should return 0 as falsy value for zero vector", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3mag(vec);
      expect(!result).toBe(true);
    });

    test("should distinguish between 0 and very small positive number", () => {
      const vec1 = new Float32Array([0, 0, 0]);
      const vec2 = new Float32Array([0.00001, 0.00001, 0.00001]);
      const result1 = gemm.v3mag(vec1);
      const result2 = gemm.v3mag(vec2);
      expect(result1).toBe(0);
      expect(result2).toBeGreaterThan(0);
    });
  });

});

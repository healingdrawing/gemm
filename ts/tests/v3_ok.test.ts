// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3_ok function using Bun's built-in test runner
 * Tests validation of 3D vectors - checks if finite AND non-zero
 */

describe("v3_ok", () => {
  describe("Valid vectors (should return true)", () => {
    test("should return true for [1,2,3]", () => {
      const vec = new Float32Array([1, 2, 3]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for [0.1,0.2,0.3]", () => {
      const vec = new Float32Array([0.1, 0.2, 0.3]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for [-1,-2,-3]", () => {
      const vec = new Float32Array([-1, -2, -3]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for mixed signs [-3,4,-5]", () => {
      const vec = new Float32Array([-3, 4, -5]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for unit vector [1,0,0]", () => {
      const vec = new Float32Array([1, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for unit vector [0,1,0]", () => {
      const vec = new Float32Array([0, 1, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for unit vector [0,0,1]", () => {
      const vec = new Float32Array([0, 0, 1]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for [100,200,300]", () => {
      const vec = new Float32Array([100, 200, 300]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for very small non-zero [0.00001,0.00001,0.00001]", () => {
      const vec = new Float32Array([0.00001, 0.00001, 0.00001]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for [1e-10, 1e-10, 1e-10]", () => {
      const vec = new Float32Array([1e-10, 1e-10, 1e-10]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for [1e10, 1e10, 1e10]", () => {
      const vec = new Float32Array([1e10, 1e10, 1e10]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });
  });

  describe("Invalid vectors - zero vector (should return false)", () => {
    test("should return false for zero vector [0,0,0]", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false when mag2 equals 0", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

  describe("Invalid vectors - NaN in components (should return false)", () => {
    test("should return false for [NaN,0,0]", () => {
      const vec = new Float32Array([NaN, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [1,NaN,3]", () => {
      const vec = new Float32Array([1, NaN, 3]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [1,2,NaN]", () => {
      const vec = new Float32Array([1, 2, NaN]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [NaN,NaN,NaN]", () => {
      const vec = new Float32Array([NaN, NaN, NaN]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [NaN,1,1] (NaN makes mag2 NaN)", () => {
      const vec = new Float32Array([NaN, 1, 1]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

  describe("Invalid vectors - Infinity in components (should return false)", () => {
    test("should return false for [Infinity,0,0]", () => {
      const vec = new Float32Array([Infinity, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [1,2,Infinity]", () => {
      const vec = new Float32Array([1, 2, Infinity]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [-Infinity,0,0]", () => {
      const vec = new Float32Array([-Infinity, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [Infinity,Infinity,Infinity]", () => {
      const vec = new Float32Array([Infinity, Infinity, Infinity]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [Infinity,-Infinity,0]", () => {
      const vec = new Float32Array([Infinity, -Infinity, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [1e308, 1e308, 1e308] (overflow to Infinity)", () => {
      const vec = new Float32Array([1e308, 1e308, 1e308]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

  describe("Invalid vectors - NaN and Infinity mixed (should return false)", () => {
    test("should return false for [NaN,Infinity,0]", () => {
      const vec = new Float32Array([NaN, Infinity, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [Infinity,NaN,5]", () => {
      const vec = new Float32Array([Infinity, NaN, 5]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for [NaN,Infinity,Infinity]", () => {
      const vec = new Float32Array([NaN, Infinity, Infinity]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

  describe("Invalid vectors - wrong array length (should return false)", () => {
    test("should return false for empty array []", () => {
      const vec = new Float32Array([]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for 1D vector [1]", () => {
      const vec = new Float32Array([1]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for 2D vector [1,2]", () => {
      const vec = new Float32Array([1, 2]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for 4D vector [1,2,3,4]", () => {
      const vec = new Float32Array([1, 2, 3, 4]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false for 5D vector [1,2,3,4,5]", () => {
      const vec = new Float32Array([1, 2, 3, 4, 5]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases - magnitude squared boundary", () => {
    test("should return true for very small but finite magnitude", () => {
      const vec = new Float32Array([1e-20, 1e-20, 1e-20]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return false for magnitude near Number.MIN_VALUE, since can not be properly used f.e. in v3one() to normalisation. When x*x returns zero", () => {
      const minVal = Math.sqrt(Number.MIN_VALUE) / Math.sqrt(3);
      const vec = new Float32Array([minVal, minVal, minVal]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false when mag2 is exactly 0", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should return false when mag2 is slightly greater than 0, since can not be properly used f.e. in v3one() to normalisation. When x*x returns zero", () => {
      const vec = new Float32Array([Number.MIN_VALUE, 0, 0]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases - finite check specifics", () => {
    test("should return true for all positive finite values", () => {
      const vec = new Float32Array([1.5, 2.5, 3.5]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should return true for all negative finite values", () => {
      const vec = new Float32Array([-1.5, -2.5, -3.5]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(true);
    });

    test("should reject Infinity in first component", () => {
      const vec = new Float32Array([Infinity, 1, 1]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should reject Infinity in middle component", () => {
      const vec = new Float32Array([1, Infinity, 1]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });

    test("should reject Infinity in last component", () => {
      const vec = new Float32Array([1, 1, Infinity]);
      const result = gemm.v3_ok(vec);
      expect(result).toBe(false);
    });
  });

});

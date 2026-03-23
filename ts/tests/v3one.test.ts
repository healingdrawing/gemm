// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3one function using Bun's built-in test runner
 * Tests vector normalization to unit length (magnitude = 1)
 * In case of any fail (zero vector, NaN, Infinity), silently does nothing
 */

describe("v3one", () => {
  describe("Valid normalization (should normalize to unit length)", () => {
    test("should normalize [3,4,0] to [0.6,0.8,0]", () => {
      const vec = new Float32Array([3, 4, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBeCloseTo(0.6);
      expect(vec[1]).toBeCloseTo(0.8);
      expect(vec[2]).toBeCloseTo(0);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize [1,2,3] to unit vector", () => {
      const vec = new Float32Array([1, 2, 3]);
      const originalNorm = gemm.v3mag(vec);
      gemm.v3one(vec);
      const newNorm = gemm.v3mag(vec);
      expect(newNorm).toBeCloseTo(1);
      expect(vec[0]).toBeCloseTo(1 / originalNorm);
      expect(vec[1]).toBeCloseTo(2 / originalNorm);
      expect(vec[2]).toBeCloseTo(3 / originalNorm);
    });

    test("should normalize [5,12,0] to [5/13, 12/13, 0]", () => {
      const vec = new Float32Array([5, 12, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBeCloseTo(5 / 13);
      expect(vec[1]).toBeCloseTo(12 / 13);
      expect(vec[2]).toBeCloseTo(0);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize [-1,-2,-3] to unit vector", () => {
      const vec = new Float32Array([-1, -2, -3]);
      const originalNorm = gemm.v3mag(vec);
      gemm.v3one(vec);
      const newNorm = gemm.v3mag(vec);
      expect(newNorm).toBeCloseTo(1);
    });

    test("should normalize [0.1,0.2,0.3] to unit vector", () => {
      const vec = new Float32Array([0.1, 0.2, 0.3]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize large values [100,200,300]", () => {
      const vec = new Float32Array([100, 200, 300]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize very small values [0.00001,0.00001,0.00001]", () => {
      const vec = new Float32Array([0.00001, 0.00001, 0.00001]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize [1,0,0] to [1,0,0]", () => {
      const vec = new Float32Array([1, 0, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBeCloseTo(1);
      expect(vec[1]).toBeCloseTo(0);
      expect(vec[2]).toBeCloseTo(0);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize [0,1,0] to [0,1,0]", () => {
      const vec = new Float32Array([0, 1, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBeCloseTo(0);
      expect(vec[1]).toBeCloseTo(1);
      expect(vec[2]).toBeCloseTo(0);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize [0,0,1] to [0,0,1]", () => {
      const vec = new Float32Array([0, 0, 1]);
      gemm.v3one(vec);
      expect(vec[0]).toBeCloseTo(0);
      expect(vec[1]).toBeCloseTo(0);
      expect(vec[2]).toBeCloseTo(1);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should normalize mixed signs [-3,4,0]", () => {
      const vec = new Float32Array([-3, 4, 0]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
      expect(vec[0]).toBeCloseTo(-0.6);
      expect(vec[1]).toBeCloseTo(0.8);
      expect(vec[2]).toBeCloseTo(0);
    });
  });

  describe("Zero vector (should do nothing silently)", () => {
    test("should not modify zero vector [0,0,0]", () => {
      const vec = new Float32Array([0, 0, 0]);
      const original = new Float32Array([0, 0, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBe(original[0]);
      expect(vec[1]).toBe(original[1]);
      expect(vec[2]).toBe(original[2]);
    });

    test("should leave [0,0,0] as [0,0,0]", () => {
      const vec = new Float32Array([0, 0, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBe(0);
      expect(vec[1]).toBe(0);
      expect(vec[2]).toBe(0);
    });

    test("should not modify when v3mag returns 0", () => {
      const vec = new Float32Array([0, 0, 0]);
      const backup = new Float32Array(vec);
      gemm.v3one(vec);
      expect(vec).toEqual(backup);
    });
  });

  describe("NaN in components (should do nothing silently)", () => {
    test("should not modify [NaN,0,0]", () => {
      const vec = new Float32Array([NaN, 0, 0]);
      const original = new Float32Array([NaN, 0, 0]);
      gemm.v3one(vec);
      expect(Number.isNaN(vec[0])).toBe(true);
      expect(vec[1]).toBe(0);
      expect(vec[2]).toBe(0);
    });

    test("should not modify [1,NaN,3]", () => {
      const vec = new Float32Array([1, NaN, 3]);
      gemm.v3one(vec);
      expect(vec[0]).toBe(1);
      expect(Number.isNaN(vec[1])).toBe(true);
      expect(vec[2]).toBe(3);
    });

    test("should not modify [1,2,NaN]", () => {
      const vec = new Float32Array([1, 2, NaN]);
      gemm.v3one(vec);
      expect(vec[0]).toBe(1);
      expect(vec[1]).toBe(2);
      expect(Number.isNaN(vec[2])).toBe(true);
    });

    test("should not modify [NaN,NaN,NaN]", () => {
      const vec = new Float32Array([NaN, NaN, NaN]);
      gemm.v3one(vec);
      expect(Number.isNaN(vec[0])).toBe(true);
      expect(Number.isNaN(vec[1])).toBe(true);
      expect(Number.isNaN(vec[2])).toBe(true);
    });

    test("should not modify [NaN,1,1] (v3mag returns 0 due to NaN)", () => {
      const vec = new Float32Array([NaN, 1, 1]);
      const backup = [vec[0], vec[1], vec[2]];
      gemm.v3one(vec);
      expect(Number.isNaN(vec[0])).toBe(backup[0] === NaN || Number.isNaN(backup[0]));
      expect(vec[1]).toBe(backup[1]);
      expect(vec[2]).toBe(backup[2]);
    });
  });

  // describe("Infinity in components (should do nothing silently)", () => {
    // test("should not modify [Infinity,0,0]", () => {
    //   const vec = new Float32Array([Infinity, 0, 0]);
    //   const original = new Float32Array([Infinity, 0, 0]);
    //   gemm.v3one(vec);
    //   expect(vec[0]).toBe(Infinity);
    //   expect(vec[1]).toBe(0);
    //   expect(vec[2]).toBe(0);
    // });

    // test("should not modify [1,2,Infinity]", () => {
    //   const vec = new Float32Array([1, 2, Infinity]);
    //   gemm.v3one(vec);
    //   expect(vec[0]).toBe(1);
    //   expect(vec[1]).toBe(2);
    //   expect(vec[2]).toBe(Infinity);
    // });

    // test("should not modify [-Infinity,0,0]", () => {
    //   const vec = new Float32Array([-Infinity, 0, 0]);
    //   gemm.v3one(vec);
    //   expect(vec[0]).toBe(-Infinity);
    //   expect(vec[1]).toBe(0);
    //   expect(vec[2]).toBe(0);
    // });

    // test("should not modify [Infinity,Infinity,Infinity]", () => {
    //   const vec = new Float32Array([Infinity, Infinity, Infinity]);
    //   gemm.v3one(vec);
    //   expect(vec[0]).toBe(Infinity);
    //   expect(vec[1]).toBe(Infinity);
    //   expect(vec[2]).toBe(Infinity);
    // });

    // test("should not modify [Infinity,-Infinity,0]", () => {
    //   const vec = new Float32Array([Infinity, -Infinity, 0]);
    //   gemm.v3one(vec);
    //   expect(vec[0]).toBe(Infinity);
    //   expect(vec[1]).toBe(-Infinity);
    //   expect(vec[2]).toBe(0);
    // });

    // test("should not modify [1e308, 1e308, 1e308] (overflow to Infinity)", () => {
    //   const vec = new Float32Array([1e308, 1e308, 1e308]);
    //   const backup = new Float32Array(vec);
    //   gemm.v3one(vec);
    //   expect(vec[0]).toBe(backup[0]);
    //   expect(vec[1]).toBe(backup[1]);
    //   expect(vec[2]).toBe(backup[2]);
    // });
  // });

  describe("Edge cases - mutation behavior", () => {
    test("should mutate the input array in place", () => {
      const vec = new Float32Array([3, 4, 0]);
      const originalRef = vec;
      gemm.v3one(vec);
      expect(vec === originalRef).toBe(true);
    });

    test("should modify all three components", () => {
      const vec = new Float32Array([2, 2, 1]);
      gemm.v3one(vec);
      expect(vec[0]).not.toBe(2);
      expect(vec[1]).not.toBe(2);
      expect(vec[2]).not.toBe(1);
    });

    test("should return undefined (no return value)", () => {
      const vec = new Float32Array([1, 2, 3]);
      const result = gemm.v3one(vec);
      expect(result).toBeUndefined();
    });

    test("should handle already normalized vector [1,0,0]", () => {
      const vec = new Float32Array([1, 0, 0]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should handle already normalized vector [0,1,0]", () => {
      const vec = new Float32Array([0, 1, 0]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });
  });

  describe("Precision and numerical stability", () => {
    test("should normalize vector with very different magnitudes [1000,0.001,0]", () => {
      const vec = new Float32Array([1000, 0.001, 0]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });

    test("should maintain sign after normalization", () => {
      const vec = new Float32Array([-5, -12, 0]);
      gemm.v3one(vec);
      expect(vec[0]).toBeLessThan(0);
      expect(vec[1]).toBeLessThan(0);
      expect(vec[2]).toBe(0);
    });

    test("should normalize [1,1,1] correctly", () => {
      const vec = new Float32Array([1, 1, 1]);
      const expectedVal = 1 / Math.sqrt(3);
      gemm.v3one(vec);
      expect(vec[0]).toBeCloseTo(expectedVal);
      expect(vec[1]).toBeCloseTo(expectedVal);
      expect(vec[2]).toBeCloseTo(expectedVal);
    });

    test("should normalize [1e-20, 1e-20, 1e-20] to unit vector", () => {
      const vec = new Float32Array([1e-20, 1e-20, 1e-20]);
      gemm.v3one(vec);
      expect(gemm.v3mag(vec)).toBeCloseTo(1);
    });
  });

  describe("Silent failure scenarios", () => {
    test("should silently fail and not throw on zero vector", () => {
      const vec = new Float32Array([0, 0, 0]);
      expect(() => gemm.v3one(vec)).not.toThrow();
    });

    test("should silently fail and not throw on NaN vector", () => {
      const vec = new Float32Array([NaN, 1, 1]);
      expect(() => gemm.v3one(vec)).not.toThrow();
    });

    test("should silently fail and not throw on Infinity vector", () => {
      const vec = new Float32Array([Infinity, 0, 0]);
      expect(() => gemm.v3one(vec)).not.toThrow();
    });

    test("should silently fail on zero vector without error message", () => {
      const vec = new Float32Array([0, 0, 0]);
      const result = gemm.v3one(vec);
      expect(result).toBeUndefined();
    });
  });

});

// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDcos function using Bun's built-in test runner
 * Tests cosine similarity calculation between n-dimensional vectors
 * Cosine similarity measures the angle between vectors: cos(θ) = (a·b) / (|a||b|)
 * Result is normalized to [-1, 1] range
 */

describe("vecXDcos", () => {
  describe("Identical vectors", () => {
    test("should return 1 for identical 2D vectors [1,0]", () => {
      const vec = [1, 0];
      const result = gemm.vecXDcos(vec, vec);
      expect(result).toBe(1);
    });

    test("should return 1 for identical 3D vectors [1,2,3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBe(1);
    });

    test("should return 1 for identical unit vectors [0,1,0]", () => {
      const vec = [0, 1, 0];
      const result = gemm.vecXDcos(vec, vec);
      expect(result).toBe(1);
    });

    test("should return 1 for scaled identical vectors [2,4] and [4,8]", () => {
      const vecA = [2, 4];
      const vecB = [4, 8];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Orthogonal vectors (perpendicular)", () => {
    test("should return 0 for orthogonal 2D vectors [1,0] and [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should return 0 for orthogonal 3D vectors [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should return 0 for orthogonal vectors [1,0,0] and [0,0,1]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 0, 1];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should return 0 for orthogonal vectors [1,1,0] and [1,-1,0]", () => {
      const vecA = [1, 1, 0];
      const vecB = [1, -1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });
  });

  describe("Opposite vectors (180 degrees)", () => {
    test("should return -1 for opposite 2D vectors [1,0] and [-1,0]", () => {
      const vecA = [1, 0];
      const vecB = [-1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(-1);
    });

    test("should return -1 for opposite 3D vectors [1,2,3] and [-1,-2,-3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-1, -2, -3];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(-1);
    });

    test("should return -1 for opposite unit vectors [0,1,0] and [0,-1,0]", () => {
      const vecA = [0, 1, 0];
      const vecB = [0, -1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(-1);
    });
  });

  describe("Known angle calculations", () => {
    test("should return cos(60°) ≈ 0.5 for 60-degree angle", () => {
      const vecA = [1, 0];
      const vecB = [Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(0.5, 5);
    });

    test("should return cos(45°) ≈ 0.707 for 45-degree angle", () => {
      const vecA = [1, 0];
      const vecB = [Math.cos(Math.PI / 4), Math.sin(Math.PI / 4)];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(Math.cos(Math.PI / 4), 5);
    });

    test("should return cos(30°) ≈ 0.866 for 30-degree angle", () => {
      const vecA = [1, 0];
      const vecB = [Math.cos(Math.PI / 6), Math.sin(Math.PI / 6)];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(Math.cos(Math.PI / 6), 5);
    });

    test("should return cos(120°) ≈ -0.5 for 120-degree angle", () => {
      const vecA = [1, 0];
      const vecB = [Math.cos((2 * Math.PI) / 3), Math.sin((2 * Math.PI) / 3)];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(-0.5, 5);
    });
  });

  describe("Zero vector handling", () => {
    test("should return 0 when first vector is zero [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when second vector is zero [0,0]", () => {
      const vecA = [1, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when both vectors are zero [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when first vector is zero in 3D [0,0,0]", () => {
      const vecA = [0, 0, 0];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBe(0);
    });
  });

  describe("Different dimensions", () => {
    test("should work with 2D vectors", () => {
      const vecA = [3, 4];
      const vecB = [4, 3];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(24 / 25); // (12+12)/(5*5)
    });

    test("should work with 3D vectors", () => {
      const vecA = [1, 0, 0];
      const vecB = [1, 1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(1 / Math.sqrt(2), 5); // 1/(1*sqrt(2))
    });

    test("should work with 4D vectors", () => {
      const vecA = [1, 0, 0, 0];
      const vecB = [1, 1, 1, 1];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(1 / 2, 5); // 1/(1*2)
    });

    test("should work with 5D vectors", () => {
      const vecA = [1, 1, 1, 1, 1];
      const vecB = [1, 1, 1, 1, 1];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Floating-point precision handling", () => {
    test("should clamp result > 1 due to floating-point error", () => {
      const vecA = [1, 0];
      const vecB = [1, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeLessThanOrEqual(1);
      expect(result).toBeGreaterThanOrEqual(-1);
    });

    test("should clamp result < -1 due to floating-point error", () => {
      const vecA = [1, 0, 0];
      const vecB = [-1, 0, 0];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeLessThanOrEqual(1);
      expect(result).toBeGreaterThanOrEqual(-1);
    });

    test("should handle very small magnitude vectors", () => {
      const vecA = [1e-10, 1e-10];
      const vecB = [1e-10, 1e-10];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBe(1);
    });

    test("should handle very large magnitude vectors", () => {
      const vecA = [1e10, 1e10];
      const vecB = [1e10, 1e10];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Commutative property", () => {
    test("should return same result regardless of vector order", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result1 = gemm.vecXDcos(vecA, vecB);
      const result2 = gemm.vecXDcos(vecB, vecA);
      expect(result1).toBeCloseTo(result2);
    });

    test("should return same result for different vector pairs", () => {
      const vecA = [3, 4];
      const vecB = [5, 12];
      const result1 = gemm.vecXDcos(vecA, vecB);
      const result2 = gemm.vecXDcos(vecB, vecA);
      expect(result1).toBeCloseTo(result2);
    });
  });

  describe("Negative components", () => {
    test("should handle vectors with negative components", () => {
      const vecA = [-1, -2];
      const vecB = [-1, -2];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(1);
    });

    test("should calculate correct angle with mixed signs", () => {
      const vecA = [1, -1];
      const vecB = [1, 1];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should handle opposite vectors with negative components", () => {
      const vecA = [-1, -2, -3];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDcos(vecA, vecB);
      expect(result).toBeCloseTo(-1);
    });
  });
});

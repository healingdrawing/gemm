// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDscalar function using Bun's built-in test runner
 * Tests scalar (dot) product calculation for n-dimensional vectors
 * Scalar product = sum of element-wise products of two vectors
 */

describe("vecXDscalar", () => {
  describe("Basic scalar product calculation", () => {
    test("should calculate scalar product for 2D vectors [1,2] · [3,4]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(11); // (1*3) + (2*4) = 3 + 8
    });

    test("should calculate scalar product for 3D vectors [1,2,3] · [4,5,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(32); // (1*4) + (2*5) + (3*6) = 4 + 10 + 18
    });

    test("should calculate scalar product for 4D vectors [1,1,1,1] · [2,2,2,2]", () => {
      const vecA = [1, 1, 1, 1];
      const vecB = [2, 2, 2, 2];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(8); // (1*2) + (1*2) + (1*2) + (1*2)
    });

    test("should calculate scalar product for [2,3] · [4,5]", () => {
      const vecA = [2, 3];
      const vecB = [4, 5];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(23); // (2*4) + (3*5) = 8 + 15
    });

    test("should calculate scalar product for [5,12] · [3,4]", () => {
      const vecA = [5, 12];
      const vecB = [3, 4];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(63); // (5*3) + (12*4) = 15 + 48
    });
  });

  describe("Zero vectors", () => {
    test("should return 0 for zero vector [0,0] · [1,2]", () => {
      const vecA = [0, 0];
      const vecB = [1, 2];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 for [1,2] · zero vector [0,0]", () => {
      const vecA = [1, 2];
      const vecB = [0, 0];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 for both zero vectors [0,0] · [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 for 3D zero vectors [0,0,0] · [5,6,7]", () => {
      const vecA = [0, 0, 0];
      const vecB = [5, 6, 7];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });
  });

  describe("Unit vectors and orthogonality", () => {
    test("should return 1 for unit vectors [1,0] · [1,0]", () => {
      const vecA = [1, 0];
      const vecB = [1, 0];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(1);
    });

    test("should return 0 for orthogonal vectors [1,0] · [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 for orthogonal 3D vectors [1,0,0] · [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 for orthogonal 3D vectors [1,0,0] · [0,0,1]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 0, 1];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 3 for [1,1,1] · [1,1,1]", () => {
      const vecA = [1, 1, 1];
      const vecB = [1, 1, 1];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(3);
    });
  });

  describe("Negative values", () => {
    test("should calculate scalar product with negative values [-1,2] · [3,-4]", () => {
      const vecA = [-1, 2];
      const vecB = [3, -4];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(-11); // (-1*3) + (2*-4) = -3 - 8
    });

    test("should calculate scalar product for [-1,-1] · [-1,-1]", () => {
      const vecA = [-1, -1];
      const vecB = [-1, -1];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(2); // (-1*-1) + (-1*-1)
    });

    test("should calculate scalar product for [1,-2,3] · [-4,5,-6]", () => {
      const vecA = [1, -2, 3];
      const vecB = [-4, 5, -6];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(-32); // (1*-4) + (-2*5) + (3*-6) = -4 - 10 - 18
    });
  });

  describe("Floating-point values", () => {
    test("should calculate scalar product for decimal vectors [0.5, 0.5] · [2, 2]", () => {
      const vecA = [0.5, 0.5];
      const vecB = [2, 2];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBeCloseTo(2); // (0.5*2) + (0.5*2) = 1 + 1
    });

    test("should calculate scalar product for [1.5, 2.5] · [3, 4]", () => {
      const vecA = [1.5, 2.5];
      const vecB = [3, 4];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBeCloseTo(14.5); // (1.5*3) + (2.5*4) = 4.5 + 10
    });

    test("should calculate scalar product for normalized vectors", () => {
      const vecA = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
      const vecB = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBeCloseTo(1); // Unit vectors dotted with themselves = 1
    });

    test("should calculate scalar product with very small values", () => {
      const vecA = [0.0001, 0.0002];
      const vecB = [0.0003, 0.0004];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBeCloseTo(0.00000011); // (0.0001*0.0003) + (0.0002*0.0004)
    });
  });

  describe("Mismatched vector lengths", () => {
    test("should return 0 when vectors have different lengths [1,2] · [3,4,5]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4, 5];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when first vector is longer [1,2,3,4] · [5,6]", () => {
      const vecA = [1, 2, 3, 4];
      const vecB = [5, 6];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when second vector is longer [1,2] · [3,4,5,6]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4, 5, 6];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 for empty and non-empty vector [] · [1,2]", () => {
      const vecA: Array<number> = [];
      const vecB = [1, 2];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });
  });

  describe("Single element vectors", () => {
    test("should calculate scalar product for single element [5] · [3]", () => {
      const vecA = [5];
      const vecB = [3];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(15); // 5 * 3
    });

    test("should return 0 for single element zero vectors [0] · [5]", () => {
      const vecA = [0];
      const vecB = [5];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should calculate scalar product for single negative element [-2] · [7]", () => {
      const vecA = [-2];
      const vecB = [7];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(-14);
    });
  });

  describe("High-dimensional vectors", () => {
    test("should calculate scalar product for 5D vector", () => {
      const vecA = [1, 2, 3, 4, 5];
      const vecB = [2, 3, 4, 5, 6];
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(70); // (1*2) + (2*3) + (3*4) + (4*5) + (5*6) = 2+6+12+20+30
    });

    test("should calculate scalar product for 10D vector", () => {
      const vecA = Array(10).fill(1);
      const vecB = Array(10).fill(2);
      const result = gemm.vecXDscalar(vecA, vecB);
      expect(result).toBe(20); // 10 elements, each 1*2
    });
  });

  describe("Commutative property", () => {
    test("should satisfy commutative property: a·b = b·a", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result1 = gemm.vecXDscalar(vecA, vecB);
      const result2 = gemm.vecXDscalar(vecB, vecA);
      expect(result1).toBe(result2);
    });

    test("should satisfy commutative property for negative values", () => {
      const vecA = [-1, 2, -3];
      const vecB = [4, -5, 6];
      const result1 = gemm.vecXDscalar(vecA, vecB);
      const result2 = gemm.vecXDscalar(vecB, vecA);
      expect(result1).toBe(result2);
    });
  });
});

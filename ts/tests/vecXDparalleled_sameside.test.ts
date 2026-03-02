// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDparalleled_sameside function using Bun's built-in test runner
 * Tests parallel vectors with same direction in n-dimensional space
 */

describe("vecXDparalleled_sameside", () => {
  describe("Parallel vectors with same direction (scalar multiples)", () => {
    test("should return true for identical 2D vectors [2,3] and [2,3]", () => {
      const vecA = [2, 3];
      const vecB = [2, 3];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel 2D vectors [1,2] and [2,4]", () => {
      const vecA = [1, 2];
      const vecB = [2, 4];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel 2D vectors [3,4] and [6,8]", () => {
      const vecA = [3, 4];
      const vecB = [6, 8];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel 3D vectors [1,2,3] and [2,4,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [2, 4, 6];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel 3D vectors [1,0,0] and [5,0,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [5, 0, 0];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel vectors with fractional scalar [2,4] and [1,2]", () => {
      const vecA = [2, 4];
      const vecB = [1, 2];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel 4D vectors [1,1,1,1] and [3,3,3,3]", () => {
      const vecA = [1, 1, 1, 1];
      const vecB = [3, 3, 3, 3];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });
  });

  describe("Parallel vectors with opposite direction (negative scalar multiples)", () => {
    test("should return false for opposite 2D vectors [1,2] and [-1,-2]", () => {
      const vecA = [1, 2];
      const vecB = [-1, -2];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for opposite 2D vectors [3,4] and [-6,-8]", () => {
      const vecA = [3, 4];
      const vecB = [-6, -8];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for opposite 3D vectors [1,2,3] and [-2,-4,-6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-2, -4, -6];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for opposite 3D vectors [1,0,0] and [-5,0,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [-5, 0, 0];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Non-parallel vectors", () => {
    test("should return false for perpendicular 2D vectors [1,0] and [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for perpendicular 3D vectors [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel 2D vectors [1,2] and [2,3]", () => {
      const vecA = [1, 2];
      const vecB = [2, 3];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel 3D vectors [1,2,3] and [3,2,1]", () => {
      const vecA = [1, 2, 3];
      const vecB = [3, 2, 1];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 45-degree angle 2D vectors [1,0] and [1,1]", () => {
      const vecA = [1, 0];
      const vecB = [1, 1];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Length mismatch", () => {
    test("should return false for vectors of different lengths [1,2] vs [1,2,3]", () => {
      const vecA = [1, 2];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 2D vs 4D vectors [1,1] vs [1,1,1,1]", () => {
      const vecA = [1, 1];
      const vecB = [1, 1, 1, 1];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for single element vs multiple elements [5] vs [5,5]", () => {
      const vecA = [5];
      const vecB = [5, 5];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases with zero and unit vectors", () => {
    test("should return true for identical zero vectors [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical unit vectors [1,0]", () => {
      const vecA = [1, 0];
      const vecB = [1, 0];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel unit vectors in same direction [0,1] and [0,1]", () => {
      const vecA = [0, 1];
      const vecB = [0, 1];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for normalized parallel vectors [1/sqrt(2), 1/sqrt(2)] and [2/sqrt(2), 2/sqrt(2)]", () => {
      const vecA = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
      const vecB = [2 / Math.sqrt(2), 2 / Math.sqrt(2)];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });
  });

  describe("High-dimensional vectors", () => {
    test("should return true for parallel 5D vectors [1,2,3,4,5] and [2,4,6,8,10]", () => {
      const vecA = [1, 2, 3, 4, 5];
      const vecB = [2, 4, 6, 8, 10];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return false for opposite direction 5D vectors [1,2,3,4,5] and [-1,-2,-3,-4,-5]", () => {
      const vecA = [1, 2, 3, 4, 5];
      const vecB = [-1, -2, -3, -4, -5];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel 5D vectors [1,0,0,0,0] and [0,1,0,0,0]", () => {
      const vecA = [1, 0, 0, 0, 0];
      const vecB = [0, 1, 0, 0, 0];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Decimal and negative values", () => {
    test("should return true for parallel decimal vectors [1.5,2.5] and [3,5]", () => {
      const vecA = [1.5, 2.5];
      const vecB = [3, 5];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for parallel negative vectors [-1,-2,-3] and [-2,-4,-6]", () => {
      const vecA = [-1, -2, -3];
      const vecB = [-2, -4, -6];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return false for opposite negative vectors [-1,-2] and [1,2]", () => {
      const vecA = [-1, -2];
      const vecB = [1, 2];
      const result = gemm.vecXDparalleled_sameside(vecA, vecB);
      expect(result).toBe(false);
    });
  });

});

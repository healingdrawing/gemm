// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDparalleled function using Bun's built-in test runner
 * Tests detection of parallel vectors (same or opposite direction) in n-dimensional space
 */

describe("vecXDparalleled", () => {
  describe("Same direction parallel vectors", () => {
    test("should return true for same direction 2D vectors [1,0] and [2,0]", () => {
      const vecA = [1, 0];
      const vecB = [2, 0];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for same direction vectors [2,3] and [4,6]", () => {
      const vecA = [2, 3];
      const vecB = [4, 6];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for same direction 3D vectors [1,2,3] and [2,4,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [2, 4, 6];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for same direction vectors [3,4,5] and [6,8,10]", () => {
      const vecA = [3, 4, 5];
      const vecB = [6, 8, 10];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for same direction decimal vectors [1.5,2.5] and [3,5]", () => {
      const vecA = [1.5, 2.5];
      const vecB = [3, 5];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for same direction 4D vectors [1,1,1,1] and [2,2,2,2]", () => {
      const vecA = [1, 1, 1, 1];
      const vecB = [2, 2, 2, 2];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for same direction with large scale [1,2] and [100,200]", () => {
      const vecA = [1, 2];
      const vecB = [100, 200];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });
  });

  describe("Opposite direction parallel vectors", () => {
    test("should return true for opposite direction 2D vectors [1,0] and [-1,0]", () => {
      const vecA = [1, 0];
      const vecB = [-1, 0];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite direction vectors [2,3] and [-2,-3]", () => {
      const vecA = [2, 3];
      const vecB = [-2, -3];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite direction 3D vectors [1,2,3] and [-1,-2,-3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-1, -2, -3];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite direction vectors [3,4,5] and [-3,-4,-5]", () => {
      const vecA = [3, 4, 5];
      const vecB = [-3, -4, -5];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for scaled opposite vectors [2,4] and [-1,-2]", () => {
      const vecA = [2, 4];
      const vecB = [-1, -2];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for scaled opposite vectors [6,9,12] and [-2,-3,-4]", () => {
      const vecA = [6, 9, 12];
      const vecB = [-2, -3, -4];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite direction decimal vectors [1.5,2.5] and [-1.5,-2.5]", () => {
      const vecA = [1.5, 2.5];
      const vecB = [-1.5, -2.5];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite direction with large scale [1,2] and [-100,-200]", () => {
      const vecA = [1, 2];
      const vecB = [-100, -200];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });
  });

  describe("Non-parallel vectors", () => {
    test("should return false for perpendicular vectors [1,0] and [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [1,2] and [3,4]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel 3D vectors [1,2,3] and [4,5,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [1,0,0] and [0,0,1]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 0, 1];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [2,3,4] and [-1,-3,5]", () => {
      const vecA = [2, 3, 4];
      const vecB = [-1, -3, 5];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for partially opposite vectors [1,2,3] and [-1,-2,3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-1, -2, 3];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for nearly parallel but not exact vectors [1,2] and [2,4.1]", () => {
      const vecA = [1, 2];
      const vecB = [2, 4.1];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Length mismatch", () => {
    test("should return false for vectors of different lengths [1,2] vs [1,2,3]", () => {
      const vecA = [1, 2];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 2D vs 4D vectors [1,0] vs [1,0,0,0]", () => {
      const vecA = [1, 0];
      const vecB = [1, 0, 0, 0];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 3D vs 2D vectors [1,2,3] vs [2,4]", () => {
      const vecA = [1, 2, 3];
      const vecB = [2, 4];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for single vs multiple elements [5] vs [5,5]", () => {
      const vecA = [5];
      const vecB = [5, 5];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases", () => {
    test("should return true for identical vectors [2,3]", () => {
      const vecA = [2, 3];
      const vecB = [2, 3];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical 3D vectors [1,2,3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for zero vectors [0,0] and [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for single element vectors [5] and [10]", () => {
      const vecA = [5];
      const vecB = [10];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for single element opposite vectors [5] and [-5]", () => {
      const vecA = [5];
      const vecB = [-5];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for high-dimensional same direction vectors", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8];
      const vecB = [2, 4, 6, 8, 10, 12, 14, 16];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for high-dimensional opposite direction vectors", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8];
      const vecB = [-1, -2, -3, -4, -5, -6, -7, -8];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return false for high-dimensional non-parallel vectors", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8];
      const vecB = [1, 2, 3, 4, 5, 6, 7, 9];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return true for very small parallel vectors [0.001, 0.002] and [0.002, 0.004]", () => {
      const vecA = [0.001, 0.002];
      const vecB = [0.002, 0.004];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for very small opposite vectors [0.001, 0.002] and [-0.001, -0.002]", () => {
      const vecA = [0.001, 0.002];
      const vecB = [-0.001, -0.002];
      const result = gemm.vecXDparalleled(vecA, vecB);
      expect(result).toBe(true);
    });
  });

});

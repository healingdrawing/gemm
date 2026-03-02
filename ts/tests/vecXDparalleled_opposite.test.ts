// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDparalleled_opposite function using Bun's built-in test runner
 * Tests detection of parallel vectors with opposite directions in n-dimensional space
 */

describe("vecXDparalleled_opposite", () => {
  describe("Opposite direction parallel vectors", () => {
    test("should return true for opposite 2D vectors [1,0] and [-1,0]", () => {
      const vecA = [1, 0];
      const vecB = [-1, 0];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite 2D vectors [2,3] and [-2,-3]", () => {
      const vecA = [2, 3];
      const vecB = [-2, -3];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite 3D vectors [1,2,3] and [-1,-2,-3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-1, -2, -3];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite 3D vectors [3,4,5] and [-3,-4,-5]", () => {
      const vecA = [3, 4, 5];
      const vecB = [-3, -4, -5];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for scaled opposite vectors [2,4] and [-1,-2]", () => {
      const vecA = [2, 4];
      const vecB = [-1, -2];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for scaled opposite vectors [6,9,12] and [-2,-3,-4]", () => {
      const vecA = [6, 9, 12];
      const vecB = [-2, -3, -4];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for opposite decimal vectors [1.5,2.5] and [-1.5,-2.5]", () => {
      const vecA = [1.5, 2.5];
      const vecB = [-1.5, -2.5];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for 4D opposite vectors [1,1,1,1] and [-2,-2,-2,-2]", () => {
      const vecA = [1, 1, 1, 1];
      const vecB = [-2, -2, -2, -2];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });
  });

  describe("Same direction parallel vectors", () => {
    test("should return false for same direction vectors [1,0] and [2,0]", () => {
      const vecA = [1, 0];
      const vecB = [2, 0];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for same direction vectors [2,3] and [4,6]", () => {
      const vecA = [2, 3];
      const vecB = [4, 6];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for same direction 3D vectors [1,2,3] and [2,4,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [2, 4, 6];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for same direction decimal vectors [1.5,2.5] and [3,5]", () => {
      const vecA = [1.5, 2.5];
      const vecB = [3, 5];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Non-parallel vectors", () => {
    test("should return false for perpendicular vectors [1,0] and [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [1,2] and [3,4]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel 3D vectors [1,2,3] and [4,5,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for non-parallel vectors [2,3,4] and [-1,-3,5]", () => {
      const vecA = [2, 3, 4];
      const vecB = [-1, -3, 5];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Length mismatch", () => {
    test("should return false for vectors of different lengths [1,2] vs [1,2,3]", () => {
      const vecA = [1, 2];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 2D vs 4D vectors [1,0] vs [1,0,0,0]", () => {
      const vecA = [1, 0];
      const vecB = [1, 0, 0, 0];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 3D vs 2D opposite vectors [1,2,3] vs [-1,-2]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-1, -2];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for single vs multiple elements [5] vs [-5,-5]", () => {
      const vecA = [5];
      const vecB = [-5, -5];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases", () => {
    test("should return true for opposite zero-like vectors [0,0] and [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for single element opposite vectors [5] and [-5]", () => {
      const vecA = [5];
      const vecB = [-5];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for single element opposite vectors [0] and [0]", () => {
      const vecA = [0];
      const vecB = [0];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for large scaled opposite vectors [100,200,300] and [-1,-2,-3]", () => {
      const vecA = [100, 200, 300];
      const vecB = [-1, -2, -3];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for very small opposite vectors [0.001,0.002] and [-0.001,-0.002]", () => {
      const vecA = [0.001, 0.002];
      const vecB = [-0.001, -0.002];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for high-dimensional opposite vectors", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8];
      const vecB = [-1, -2, -3, -4, -5, -6, -7, -8];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return false for high-dimensional same direction vectors", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8];
      const vecB = [2, 4, 6, 8, 10, 12, 14, 16];
      const result = gemm.vecXDparalleled_opposite(vecA, vecB);
      expect(result).toBe(false);
    });
  });

});

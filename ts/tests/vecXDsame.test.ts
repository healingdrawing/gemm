// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDsame function using Bun's built-in test runner
 * Tests vector equality comparison in n-dimensional space
 */

describe("vecXDsame", () => {
  describe("Identical vectors", () => {
    test("should return true for identical 2D vectors [2,3]", () => {
      const vecA = [2, 3];
      const vecB = [2, 3];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical 3D vectors [1,2,2]", () => {
      const vecA = [1, 2, 2];
      const vecB = [1, 2, 2];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical 4D vectors [1,1,1,1]", () => {
      const vecA = [1, 1, 1, 1];
      const vecB = [1, 1, 1, 1];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical zero vectors [0,0,0]", () => {
      const vecA = [0, 0, 0];
      const vecB = [0, 0, 0];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical negative vectors [-1,-2,-3]", () => {
      const vecA = [-1, -2, -3];
      const vecB = [-1, -2, -3];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for identical decimal vectors [1.5, 2.7, 3.14]", () => {
      const vecA = [1.5, 2.7, 3.14];
      const vecB = [1.5, 2.7, 3.14];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });
  });

  describe("Different vectors", () => {
    test("should return false for different 2D vectors [2,3] vs [2,4]", () => {
      const vecA = [2, 3];
      const vecB = [2, 4];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for different 3D vectors [1,2,2] vs [1,2,3]", () => {
      const vecA = [1, 2, 2];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for completely different vectors [1,1,1] vs [2,2,2]", () => {
      const vecA = [1, 1, 1];
      const vecB = [2, 2, 2];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for opposite sign vectors [1,2] vs [-1,-2]", () => {
      const vecA = [1, 2];
      const vecB = [-1, -2];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Length mismatch", () => {
    test("should return false for vectors of different lengths [1,2] vs [1,2,3]", () => {
      const vecA = [1, 2];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for 2D vs 4D vectors [1,2] vs [1,2,3,4]", () => {
      const vecA = [1, 2];
      const vecB = [1, 2, 3, 4];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for empty vs non-empty vector [] vs [1]", () => {
      const vecA: Array<number> = [];
      const vecB = [1];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return false for single element vs multiple elements [5] vs [5,5]", () => {
      const vecA = [5];
      const vecB = [5, 5];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases", () => {
    test("should return true for both empty vectors []", () => {
      const vecA: Array<number> = [];
      const vecB: Array<number> = [];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return true for single identical element vectors [42]", () => {
      const vecA = [42];
      const vecB = [42];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return false for single different element vectors [1] vs [2]", () => {
      const vecA = [1];
      const vecB = [2];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });

    test("should return true for large dimension vectors (10D)", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const vecB = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(true);
    });

    test("should return false when only last element differs in large vector", () => {
      const vecA = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const vecB = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11];
      const result = gemm.vecXDsame(vecA, vecB);
      expect(result).toBe(false);
    });
  });

});

// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for same_size_F function using Bun's built-in test runner
 */

describe("same_size_F", () => {
  describe("Basic same size validation", () => {
    test("should return true for two arrays of equal size", () => {
      const a = [[1, 2, 3], [4, 5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true for three arrays of equal size", () => {
      const a = [[1, 2], [3, 4], [5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true for multiple arrays with same size", () => {
      const a = [[1], [2], [3], [4], [5]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true for arrays with larger size", () => {
      const a = [
        [1, 2, 3, 4, 5],
        [6, 7, 8, 9, 10],
        [11, 12, 13, 14, 15]
      ];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });
  });

  describe("Different sizes detection", () => {
    test("should return false for arrays of different sizes", () => {
      const a = [[1, 2, 3], [4, 5]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false when second array is smaller", () => {
      const a = [[1, 2, 3, 4], [5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false when second array is larger", () => {
      const a = [[1, 2], [3, 4, 5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false when middle array differs in size", () => {
      const a = [[1, 2, 3], [4, 5], [6, 7, 8]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false when last array differs in size", () => {
      const a = [[1, 2, 3], [4, 5, 6], [7, 8]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false for multiple arrays with one different size", () => {
      const a = [[1, 2], [3, 4], [5, 6], [7, 8, 9]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases - empty and single arrays", () => {
    test("should return true for single array", () => {
      const a = [[1, 2, 3]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return false for empty outer array", () => {
      const a: Array<Array<number>> = [];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return true for two empty inner arrays", () => {
      const a = [[], []];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return false for one empty and one non-empty array", () => {
      const a = [[], [1, 2, 3]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false for multiple arrays with one empty", () => {
      const a = [[1, 2], [3, 4], []];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });
  });

  describe("Size one arrays", () => {
    test("should return true for multiple single-element arrays", () => {
      const a = [[1], [2], [3], [4]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return false when comparing single-element with multi-element", () => {
      const a = [[1], [2, 3]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });
  });

  describe("Numeric value variations", () => {
    test("should return true regardless of numeric values (all positive)", () => {
      const a = [[1, 2, 3], [100, 200, 300]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true regardless of numeric values (mixed signs)", () => {
      const a = [[-1, 2, -3], [4, -5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true regardless of numeric values (decimals)", () => {
      const a = [[1.5, 2.7, 3.9], [0.1, 0.2, 0.3]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true with zero values", () => {
      const a = [[0, 0, 0], [1, 2, 3]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true with very large numbers", () => {
      const a = [[1e10, 2e10], [3e10, 4e10]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true with very small numbers", () => {
      const a = [[1e-10, 2e-10], [3e-10, 4e-10]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true with NaN values", () => {
      const a = [[NaN, 2, 3], [4, NaN, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true with Infinity values", () => {
      const a = [[Infinity, 2, 3], [4, -Infinity, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });
  });

  describe("Large arrays", () => {
    test("should return true for large arrays with same size", () => {
      const largeArray1 = Array(1000).fill(0).map((_, i) => i);
      const largeArray2 = Array(1000).fill(0).map((_, i) => i * 2);
      const a = [largeArray1, largeArray2];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return false for large arrays with different sizes", () => {
      const largeArray1 = Array(1000).fill(0);
      const largeArray2 = Array(999).fill(0);
      const a = [largeArray1, largeArray2];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return true for many arrays with same size", () => {
      const arrays = Array(100).fill(0).map(() => Array(50).fill(0));
      const result = gemm.same_size_F(arrays);
      expect(result).toBe(true);
    });

    test("should return false for many arrays with one different size", () => {
      const arrays = Array(100).fill(0).map(() => Array(50).fill(0));
      arrays[50] = Array(51).fill(0);
      const result = gemm.same_size_F(arrays);
      expect(result).toBe(false);
    });
  });

  describe("Two array validation", () => {
    test("should return true for exactly two arrays of same size", () => {
      const a = [[1, 2, 3], [4, 5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return false for exactly two arrays of different sizes", () => {
      const a = [[1, 2, 3], [4, 5]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return true for two empty arrays", () => {
      const a = [[], []];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should return true for two single-element arrays", () => {
      const a = [[1], [2]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });
  });

  describe("Order independence", () => {
    test("should return same result regardless of array order", () => {
      const a1 = [[1, 2], [3, 4], [5, 6]];
      const a2 = [[5, 6], [1, 2], [3, 4]];
      const result1 = gemm.same_size_F(a1);
      const result2 = gemm.same_size_F(a2);
      expect(result1).toBe(result2);
    });

    test("should return false regardless of order when sizes differ", () => {
      const a1 = [[1, 2], [3, 4, 5]];
      const a2 = [[3, 4, 5], [1, 2]];
      const result1 = gemm.same_size_F(a1);
      const result2 = gemm.same_size_F(a2);
      expect(result1).toBe(false);
      expect(result2).toBe(false);
    });
  });

  describe("Boundary size differences", () => {
    test("should return false when one array is one element larger", () => {
      const a = [[1, 2, 3], [1, 2, 3, 4]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false when one array is one element smaller", () => {
      const a = [[1, 2, 3, 4], [1, 2, 3]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should return false when arrays differ by multiple elements", () => {
      const a = [[1, 2, 3], [1, 2, 3, 4, 5, 6]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });
  });

  describe("Multiple validation checks", () => {
    test("should verify all arrays when more than two exist", () => {
      const a = [[1, 2], [3, 4], [5, 6], [7, 8]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(true);
    });

    test("should fail early on first mismatch in multiple arrays", () => {
      const a = [[1, 2], [3, 4, 5], [6, 7], [8, 9]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });

    test("should check all arrays even when first two match", () => {
      const a = [[1, 2], [3, 4], [5, 6, 7]];
      const result = gemm.same_size_F(a);
      expect(result).toBe(false);
    });
  });
});

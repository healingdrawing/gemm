// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for same_xF function using Bun's built-in test runner
 * Tests comparison of multiple float arrays for equality
 */

describe("same_xF", () => {
  describe("Equal arrays", () => {
    test("should return true for two identical 2D arrays", () => {
      const arrays = [[1, 2, 3], [1, 2, 3]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for three identical arrays", () => {
      const arrays = [[5, 10, 15], [5, 10, 15], [5, 10, 15]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for arrays with floating point values", () => {
      const arrays = [[1.5, 2.7, 3.14], [1.5, 2.7, 3.14]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for arrays with negative values", () => {
      const arrays = [[-1, -2, -3], [-1, -2, -3]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for single element arrays", () => {
      const arrays = [[42], [42], [42]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for zero arrays", () => {
      const arrays = [[0, 0, 0], [0, 0, 0]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });
  });

  describe("Unequal arrays", () => {
    test("should return false when arrays differ in one element", () => {
      const arrays = [[1, 2, 3], [1, 2, 4]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });

    test("should return false when first element differs", () => {
      const arrays = [[1, 2, 3], [5, 2, 3]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });

    test("should return false when last element differs", () => {
      const arrays = [[1, 2, 3], [1, 2, 9]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });

    test("should return false when comparing three arrays with one mismatch", () => {
      const arrays = [[1, 2, 3], [1, 2, 3], [1, 2, 4]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });

    test("should return false for completely different arrays", () => {
      const arrays = [[1, 1, 1], [9, 9, 9]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });

    test("should return false for floating point value mismatch", () => {
      const arrays = [[1.5, 2.7, 3.14], [1.5, 2.7, 3.15]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });
  });

  describe("Edge cases", () => {
    test("should return false for empty array input", () => {
      const arrays: Array<Array<number>> = [];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });

    test("should return true for single array", () => {
      const arrays = [[1, 2, 3]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for arrays with large numbers", () => {
      const arrays = [[1000000, 2000000], [1000000, 2000000]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should return true for arrays with very small floating point numbers", () => {
      const arrays = [[0.0001, 0.0002], [0.0001, 0.0002]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });

    test("should handle arrays with mixed positive and negative values", () => {
      const arrays = [[-1, 2, -3, 4], [-1, 2, -3, 4], [-1, 2, -3, 4]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(true);
    });
  });

  describe("Size validation", () => {
    test("should rely on same_size_F for size validation", () => {
      // This test assumes same_size_F is called and returns false for different sizes
      const arrays = [[1, 2, 3], [1, 2]];
      const result = gemm.same_xF(arrays);
      expect(result).toBe(false);
    });
  });
});

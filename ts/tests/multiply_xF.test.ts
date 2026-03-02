// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for multiply_xF function using Bun's built-in test runner
 * Tests element-wise multiplication of multiple arrays (column-wise product)
 */

describe("multiply_xF", () => {
  describe("Basic multiplication of two arrays", () => {
    test("should multiply two arrays [3.1, 2] and [3, 4]", () => {
      const a = [[3.1, 2], [3, 4]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(3.1 * 3); // 9.3
      expect(result[1]).toBeCloseTo(2 * 4); // 8
    });

    test("should multiply two simple integer arrays [1, 2] and [3, 4]", () => {
      const a = [[1, 2], [3, 4]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(3); // 1 * 3
      expect(result[1]).toBe(8); // 2 * 4
    });

    test("should multiply two arrays with different values [2, 5] and [4, 3]", () => {
      const a = [[2, 5], [4, 3]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(8); // 2 * 4
      expect(result[1]).toBe(15); // 5 * 3
    });

    test("should multiply two arrays with decimals [1.5, 2.5] and [2.0, 4.0]", () => {
      const a = [[1.5, 2.5], [2.0, 4.0]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(3.0);
      expect(result[1]).toBeCloseTo(10.0);
    });
  });

  describe("Multiplication of three or more arrays", () => {
    test("should multiply three arrays [1, 2, 3], [2, 3, 4], [3, 4, 5]", () => {
      const a = [[1, 2, 3], [2, 3, 4], [3, 4, 5]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(6); // 1 * 2 * 3
      expect(result[1]).toBe(24); // 2 * 3 * 4
      expect(result[2]).toBe(60); // 3 * 4 * 5
    });

    test("should multiply four arrays of length 2", () => {
      const a = [[1, 2], [2, 3], [3, 4], [4, 5]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(24); // 1 * 2 * 3 * 4
      expect(result[1]).toBe(120); // 2 * 3 * 4 * 5
    });

    test("should multiply five arrays with single element each", () => {
      const a = [[2], [3], [4], [5], [2]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(240); // 2 * 3 * 4 * 5 * 2
    });

    test("should multiply three arrays with decimals", () => {
      const a = [[0.5, 2.0], [2.0, 0.5], [4.0, 2.0]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(4.0); // 0.5 * 2.0 * 4.0
      expect(result[1]).toBeCloseTo(2.0); // 2.0 * 0.5 * 2.0
    });
  });

  describe("Single array input", () => {
    test("should return empty array for single array input", () => {
      const a = [[1, 2, 3]];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });

    test("should return empty array for single array with one element", () => {
      const a = [[5]];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });
  });

  describe("Empty array input", () => {
    test("should return empty array for empty input", () => {
      const a = [];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });

    test("should return empty array when first array is empty", () => {
      const a = [[], []];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });
  });

  describe("Arrays with zeros", () => {
    test("should return 0 when array contains zero [1, 2] and [0, 3]", () => {
      const a = [[1, 2], [0, 3]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(0); // 1 * 0
      expect(result[1]).toBe(6); // 2 * 3
    });

    test("should return 0 when multiple arrays have zeros", () => {
      const a = [[0, 5], [2, 0], [3, 4]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(0); // 0 * 2 * 3
      expect(result[1]).toBe(0); // 5 * 0 * 4
    });

    test("should handle array with all zeros [0, 0] and [1, 2]", () => {
      const a = [[0, 0], [1, 2]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(0);
      expect(result[1]).toBe(0);
    });

    test("should handle all arrays being all zeros", () => {
      const a = [[0, 0], [0, 0]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(0);
      expect(result[1]).toBe(0);
    });
  });

  describe("Negative numbers", () => {
    test("should multiply arrays with negative numbers [-2, 3] and [4, -5]", () => {
      const a = [[-2, 3], [4, -5]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(-8); // -2 * 4
      expect(result[1]).toBe(-15); // 3 * -5
    });

    test("should multiply arrays with all negative values [-1, -2] and [-3, -4]", () => {
      const a = [[-1, -2], [-3, -4]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(3); // -1 * -3
      expect(result[1]).toBe(8); // -2 * -4
    });

    test("should handle mixed signs in three arrays", () => {
      const a = [[-1, 2], [2, -3], [3, 4]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(-6); // -1 * 2 * 3
      expect(result[1]).toBe(-24); // 2 * -3 * 4
    });

    test("should multiply with negative decimals [-0.5, 1.5] and [2.0, -2.0]", () => {
      const a = [[-0.5, 1.5], [2.0, -2.0]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(-1.0); // -0.5 * 2.0
      expect(result[1]).toBeCloseTo(-3.0); // 1.5 * -2.0
    });
  });

  describe("Size validation (same_size_F check)", () => {
    test("should return empty array when arrays have different sizes", () => {
      const a = [[1, 2, 3], [4, 5]];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });

    test("should return empty array when second array is shorter", () => {
      const a = [[1, 2, 3, 4], [5, 6]];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });

    test("should return empty array when multiple arrays have different lengths", () => {
      const a = [[1, 2], [3, 4, 5], [6, 7]];
      const result = gemm.multiply_xF(a);
      expect(result).toEqual([]);
    });
  });

  describe("Large arrays", () => {
    test("should multiply arrays with 10 elements each", () => {
      const a = [
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      ];
      const result = gemm.multiply_xF(a);
      for (let i = 0; i < 10; i++) {
        expect(result[i]).toBe(i + 1);
      }
    });

    test("should multiply three large arrays", () => {
      const a = [
        [2, 3, 4],
        [3, 2, 5],
        [4, 5, 2]
      ];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(24); // 2 * 3 * 4
      expect(result[1]).toBe(30); // 3 * 2 * 5
      expect(result[2]).toBe(40); // 4 * 5 * 2
    });
  });

  describe("Floating point precision", () => {
    test("should handle decimal multiplication with precision", () => {
      const a = [[0.1, 0.2], [0.2, 0.5]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(0.02); // 0.1 * 0.2
      expect(result[1]).toBeCloseTo(0.1); // 0.2 * 0.5
    });

    test("should handle small decimal values", () => {
      const a = [[0.001, 0.01], [0.01, 0.1]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(0.00001); // 0.001 * 0.01
      expect(result[1]).toBeCloseTo(0.001); // 0.01 * 0.1
    });

    test("should handle scientific notation", () => {
      const a = [[1e-5, 1e-3], [1e5, 1e3]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBeCloseTo(1); // 1e-5 * 1e5
      expect(result[1]).toBeCloseTo(1); // 1e-3 * 1e3
    });
  });

  describe("Special values", () => {
    test("should multiply arrays with 1 values [1, 1] and [5, 10]", () => {
      const a = [[1, 1], [5, 10]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(5);
      expect(result[1]).toBe(10);
    });

    test("should multiply arrays where result is 1", () => {
      const a = [[1, 0.5], [1, 2]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(1); // 1 * 1
      expect(result[1]).toBeCloseTo(1); // 0.5 * 2
    });

    test("should handle large result values", () => {
      const a = [[100, 1000], [1000, 100]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(100000); // 100 * 1000
      expect(result[1]).toBe(100000); // 1000 * 100
    });
  });

  describe("Column-wise multiplication verification", () => {
    test("should multiply columns correctly for 2x3 matrix", () => {
      // Column 0: [1, 2] -> 1*2 = 2
      // Column 1: [3, 4] -> 3*4 = 12
      // Column 2: [5, 6] -> 5*6 = 30
      const a = [[1, 3, 5], [2, 4, 6]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(2);
      expect(result[1]).toBe(12);
      expect(result[2]).toBe(30);
    });

    test("should multiply columns correctly for 3x2 matrix", () => {
      // Column 0: [1, 2, 3] -> 1*2*3 = 6
      // Column 1: [4, 5, 6] -> 4*5*6 = 120
      const a = [[1, 4], [2, 5], [3, 6]];
      const result = gemm.multiply_xF(a);
      expect(result[0]).toBe(6);
      expect(result[1]).toBe(120);
    });
  });
});

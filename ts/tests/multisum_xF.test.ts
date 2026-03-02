// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for multisum_xF function using Bun's built-in test runner
 * Tests element-wise multiplication of arrays followed by summation
 * Equivalent to dot product for 1D arrays or matrix element multiplication sum
 */

describe("multisum_xF", () => {
  describe("Basic 2D array multiplication and sum", () => {
    test("should multiply and sum simple 2x2 arrays [[1, 2], [3, 4]]", () => {
      const a = [[1, 2], [3, 4]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(11); // 1*3 + 2*4 = 3 + 8
    });

    test("should multiply and sum [[2, 3], [4, 5]]", () => {
      const a = [[2, 3], [4, 5]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(23); // 2*4 + 3*5 = 8 + 15
    });

    test("should multiply and sum [[1, 0], [0, 1]]", () => {
      const a = [[1, 0], [0, 1]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // 1*0 + 0*1 = 0 + 0 = 0
    });

    test("should multiply and sum [[5, 5], [2, 2]]", () => {
      const a = [[5, 5], [2, 2]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(20); // 5*2 + 5*2 = 10 + 10
    });

    test("should multiply and sum [[1, 1], [1, 1]]", () => {
      const a = [[1, 1], [1, 1]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(2); // 1*1 + 1*1 = 1 + 1
    });
  });

  describe("Arrays with different values", () => {
    test("should handle [[10, 20], [30, 40]]", () => {
      const a = [[10, 20], [30, 40]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(1100); // 10*30 + 20*40 = 300 + 800
    });

    test("should handle [[1, 2, 3], [4, 5, 6]]", () => {
      const a = [[1, 2, 3], [4, 5, 6]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(32); // 1*4 + 2*5 + 3*6 = 4 + 10 + 18
    });

    test("should handle 3x3 arrays [[1, 2, 3], [4, 5, 6], [7, 8, 9]]", () => {
      const a = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(270); // [1*4*7, 2*5*8, 3*6*9] then sum = 28 + 80 + 162 = 270
    });

    test("should handle [[2, 4], [3, 6]]", () => {
      const a = [[2, 4], [3, 6]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(30); // 2*3 + 4*6 = 6 + 24
    });
  });

  describe("Arrays with zeros", () => {
    test("should return 0 when one array is all zeros [[0, 0], [1, 2]]", () => {
      const a = [[0, 0], [1, 2]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // 0*1 + 0*2 = 0
    });

    test("should return 0 when all arrays contain zero [[1, 0], [2, 3]]", () => {
      const a = [[1, 0], [2, 3]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(2); // 1*2 + 0*3 = 2 + 0 = 2
    });

    test("should handle [[0, 0], [0, 0]]", () => {
      const a = [[0, 0], [0, 0]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0);
    });

    test("should handle [[5, 0], [0, 5]]", () => {
      const a = [[5, 0], [0, 5]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // 5*0 + 0*5 = 0
    });
  });

  describe("Negative numbers", () => {
    test("should handle negative values [[-1, -2], [-3, -4]]", () => {
      const a = [[-1, -2], [-3, -4]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(11); // (-1)*(-3) + (-2)*(-4) = 3 + 8
    });

    test("should handle mixed positive and negative [[1, -2], [3, -4]]", () => {
      const a = [[1, -2], [3, -4]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(11); // 1*3 + (-2)*(-4) = 3 + 8 = 11
    });

    test("should handle [[2, -3], [-4, 5]]", () => {
      const a = [[2, -3], [-4, 5]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(-23); // 2*(-4) + (-3)*5 = -8 + (-15) = -23
    });

    test("should handle [[-5, -5], [-2, -2]]", () => {
      const a = [[-5, -5], [-2, -2]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(20); // (-5)*(-2) + (-5)*(-2) = 10 + 10
    });
  });

  describe("Floating point numbers", () => {
    test("should handle [[1.5, 2.5], [2.0, 3.0]]", () => {
      const a = [[1.5, 2.5], [2.0, 3.0]];
      const result = gemm.multisum_xF(a);
      expect(result).toBeCloseTo(10.5); // 1.5*2.0 + 2.5*3.0 = 3.0 + 7.5
    });

    test("should handle [[0.5, 0.5], [2, 4]]", () => {
      const a = [[0.5, 0.5], [2, 4]];
      const result = gemm.multisum_xF(a);
      expect(result).toBeCloseTo(3); // 0.5*2 + 0.5*4 = 1 + 2
    });

    test("should handle [[0.1, 0.2, 0.3], [1, 2, 3]]", () => {
      const a = [[0.1, 0.2, 0.3], [1, 2, 3]];
      const result = gemm.multisum_xF(a);
      expect(result).toBeCloseTo(1.4); // 0.1*1 + 0.2*2 + 0.3*3 = 0.1 + 0.4 + 0.9
    });

    test("should handle [[1.1, 2.2], [3.3, 4.4]]", () => {
      const a = [[1.1, 2.2], [3.3, 4.4]];
      const result = gemm.multisum_xF(a);
      expect(result).toBeCloseTo(13.31); // 1.1*3.3 + 2.2*4.4 = 3.63 + 9.68 // (11*33+22*44)/100
    });
  });

  describe("Invalid input validation", () => {
    test("should return 0 for empty array []", () => {
      const a: Array<Array<number>> = [];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0);
    });

    test("should return 0 for single array [[1, 2, 3]]", () => {
      const a = [[1, 2, 3]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // length must be > 1
    });

    test("should return 0 for arrays with empty sub-arrays [[], []]", () => {
      const a: Array<Array<number>> = [[], []];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // first array length must be > 0
    });

    test("should return 0 for arrays of different sizes [[1, 2], [3, 4, 5]]", () => {
      const a = [[1, 2], [3, 4, 5]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // same_size_F should return false
    });

    test("should return 0 for arrays with different lengths [[1, 2, 3], [4, 5]]", () => {
      const a = [[1, 2, 3], [4, 5]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0);
    });
  });

  describe("Multiple arrays (more than 2)", () => {
    test("should multiply and sum three arrays [[1, 2], [3, 4], [5, 6]]", () => {
      const a = [[1, 2], [3, 4], [5, 6]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(63); // 1*3*5 + 2*4*6 = 15 + 48
    });

    test("should multiply and sum four arrays [[1, 1], [2, 2], [3, 3], [4, 4]]", () => {
      const a = [[1, 1], [2, 2], [3, 3], [4, 4]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(48); // 1*2*3*4 + 1*2*3*4 = 24 + 24 = 48
    });

    test("should multiply and sum three arrays with different values [[2, 3], [4, 5], [6, 7]]", () => {
      const a = [[2, 3], [4, 5], [6, 7]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(153); // 2*4*6 + 3*5*7 = 48 + 105 = 153
    });
  });

  describe("Large arrays", () => {
    test("should handle 2x5 arrays [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]]", () => {
      const a = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(70); // 1*2 + 2*3 + 3*4 + 4*5 + 5*6 = 2 + 6 + 12 + 20 + 30
    });

    test("should handle 3x4 arrays", () => {
      const a = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(210); // 1*2*3 + 2*3*4 + 3*4*5 + 4*5*6 = 6 + 24 + 60 + 120 = 210
    });
  });

  describe("Edge cases with ones and identity", () => {
    test("should handle arrays of all ones [[1, 1, 1], [1, 1, 1]]", () => {
      const a = [[1, 1, 1], [1, 1, 1]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(3); // 1*1 + 1*1 + 1*1 = 1 + 1 + 1
    });

    test("should handle [[1, 2, 3], [1, 1, 1]]", () => {
      const a = [[1, 2, 3], [1, 1, 1]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(6); // 1*1 + 2*1 + 3*1 = 1 + 2 + 3
    });
  });

  describe("Dot product interpretation", () => {
    test("should calculate dot product of two vectors [3, 4] and [5, 12]", () => {
      const a = [[3, 4], [5, 12]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(63); // 3*5 + 4*12 = 15 + 48
    });

    test("should calculate dot product of orthogonal vectors [1, 0] and [0, 1]", () => {
      const a = [[1, 0], [0, 1]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(0); // 1*0 + 0*1 = 0
    });

    test("should calculate dot product of parallel vectors [2, 3] and [4, 6]", () => {
      const a = [[2, 3], [4, 6]];
      const result = gemm.multisum_xF(a);
      expect(result).toBe(26); // 2*4 + 3*6 = 8 + 18
    });
  });
});

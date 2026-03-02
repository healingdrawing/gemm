// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for multiply_F function using Bun's built-in test runner
 * Tests multiplication of all elements in a floating-point array
 */

describe("multiply_F", () => {
  describe("Basic multiplication", () => {
    test("should multiply simple integers [1, 2, 3]", () => {
      const a = [1, 2, 3];
      const result = gemm.multiply_F(a);
      expect(result).toBe(6);
    });

    test("should multiply floats [1.1, 2.0, 3.0]", () => {
      const a = [1.1, 2.0, 3.0];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(6.6);
    });

    test("should multiply two elements [5, 4]", () => {
      const a = [5, 4];
      const result = gemm.multiply_F(a);
      expect(result).toBe(20);
    });

    test("should multiply single element [7]", () => {
      const a = [7];
      const result = gemm.multiply_F(a);
      expect(result).toBe(7);
    });

    test("should multiply larger array [2, 3, 4, 5]", () => {
      const a = [2, 3, 4, 5];
      const result = gemm.multiply_F(a);
      expect(result).toBe(120);
    });

    test("should multiply array with decimal values [0.5, 0.5, 4]", () => {
      const a = [0.5, 0.5, 4];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Zero in array", () => {
    test("should return 0 when array contains zero [1, 0, 3]", () => {
      const a = [1, 0, 3];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });

    test("should return 0 when zero is first element [0, 5, 10]", () => {
      const a = [0, 5, 10];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });

    test("should return 0 when zero is last element [2, 3, 0]", () => {
      const a = [2, 3, 0];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });

    test("should return 0 when array is all zeros [0, 0, 0]", () => {
      const a = [0, 0, 0];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });
  });

  describe("Empty and edge cases", () => {
    test("should return 0 for empty array []", () => {
      const a = [];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });

    test("should return 1 for array with single element [1]", () => {
      const a = [1];
      const result = gemm.multiply_F(a);
      expect(result).toBe(1);
    });

    test("should return 0 for array with single zero [0]", () => {
      const a = [0];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });
  });

  describe("Negative numbers", () => {
    test("should multiply with negative numbers [-2, 3, 4]", () => {
      const a = [-2, 3, 4];
      const result = gemm.multiply_F(a);
      expect(result).toBe(-24);
    });

    test("should multiply with all negative numbers [-2, -3, -4]", () => {
      const a = [-2, -3, -4];
      const result = gemm.multiply_F(a);
      expect(result).toBe(-24);
    });

    test("should multiply with two negative numbers [-5, -2, 3]", () => {
      const a = [-5, -2, 3];
      const result = gemm.multiply_F(a);
      expect(result).toBe(30);
    });

    test("should handle negative decimals [-1.5, 2.0, -2.0]", () => {
      const a = [-1.5, 2.0, -2.0];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(6);
    });
  });

  describe("Large numbers", () => {
    test("should multiply large integers [100, 200, 300]", () => {
      const a = [100, 200, 300];
      const result = gemm.multiply_F(a);
      expect(result).toBe(6000000);
    });

    test("should multiply very large numbers [1000, 1000, 1000]", () => {
      const a = [1000, 1000, 1000];
      const result = gemm.multiply_F(a);
      expect(result).toBe(1000000000);
    });

    test("should multiply large floats [1.5e3, 2e3]", () => {
      const a = [1.5e3, 2e3];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(3000000);
    });
  });

  describe("Small numbers and fractions", () => {
    test("should multiply small decimals [0.1, 0.2, 0.3]", () => {
      const a = [0.1, 0.2, 0.3];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(0.006);
    });

    test("should multiply very small numbers [0.001, 0.001, 1000]", () => {
      const a = [0.001, 0.001, 1000];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(0.001);
    });

    test("should multiply fractions [1/2, 1/3, 1/4]", () => {
      const a = [1/2, 1/3, 1/4];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(1/24);
    });

    test("should multiply scientific notation [1e-5, 1e-5, 1e10]", () => {
      const a = [1e-5, 1e-5, 1e10];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Mixed positive and negative", () => {
    test("should handle mixed signs [2, -3, 4, -5]", () => {
      const a = [2, -3, 4, -5];
      const result = gemm.multiply_F(a);
      expect(result).toBe(120);
    });

    test("should handle alternating signs [-1, 2, -3, 4, -5]", () => {
      const a = [-1, 2, -3, 4, -5];
      const result = gemm.multiply_F(a);
      expect(result).toBe(-120);
    });
  });

  describe("Special floating point values", () => {
    test("should multiply array with 1.0 [1.0, 2.5, 4.0]", () => {
      const a = [1.0, 2.5, 4.0];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(10);
    });

    test("should handle result of 1 [1, 1, 1, 1]", () => {
      const a = [1, 1, 1, 1];
      const result = gemm.multiply_F(a);
      expect(result).toBe(1);
    });

    test("should multiply with -1 [2, -1, 3]", () => {
      const a = [2, -1, 3];
      const result = gemm.multiply_F(a);
      expect(result).toBe(-6);
    });
  });

  describe("Long arrays", () => {
    test("should multiply array with 10 elements", () => {
      const a = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
      const result = gemm.multiply_F(a);
      expect(result).toBe(1);
    });

    test("should multiply array with 10 different values", () => {
      const a = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2];
      const result = gemm.multiply_F(a);
      expect(result).toBe(32); // 2^5
    });

    test("should multiply long array with one zero", () => {
      const a = [1, 2, 3, 4, 5, 0, 7, 8, 9, 10];
      const result = gemm.multiply_F(a);
      expect(result).toBe(0);
    });
  });

  describe("Floating point precision", () => {
    test("should handle precise decimal multiplication", () => {
      const a = [0.1, 0.2, 0.5];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(0.01);
    });

    test("should multiply numbers that test floating point precision", () => {
      const a = [0.3, 0.3, 0.3];
      const result = gemm.multiply_F(a);
      expect(result).toBeCloseTo(0.027);
    });
  });
});

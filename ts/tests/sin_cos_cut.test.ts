// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for sin_cos_cut function using Bun's built-in test runner
 * Tests normalization of sin/cos values to the range [-1, 1]
 * Handles floating-point precision errors that can produce values slightly outside bounds
 */

describe("sin_cos_cut", () => {
  describe("Normal range values", () => {
    test("should return value unchanged when within [-1, 1]", () => {
      expect(gemm.sin_cos_cut(0)).toBe(0);
    });

    test("should return 0.5 unchanged", () => {
      expect(gemm.sin_cos_cut(0.5)).toBe(0.5);
    });

    test("should return -0.5 unchanged", () => {
      expect(gemm.sin_cos_cut(-0.5)).toBe(-0.5);
    });

    test("should return 1 at upper boundary", () => {
      expect(gemm.sin_cos_cut(1)).toBe(1);
    });

    test("should return -1 at lower boundary", () => {
      expect(gemm.sin_cos_cut(-1)).toBe(-1);
    });

    test("should return 0.999999 unchanged", () => {
      expect(gemm.sin_cos_cut(0.999999)).toBe(0.999999);
    });

    test("should return -0.999999 unchanged", () => {
      expect(gemm.sin_cos_cut(-0.999999)).toBe(-0.999999);
    });
  });

  describe("Floating-point overflow correction", () => {
    test("should clamp 1.00000000001 to 1", () => {
      expect(gemm.sin_cos_cut(1.00000000001)).toBe(1);
    });

    test("should clamp 1.0000001 to 1", () => {
      expect(gemm.sin_cos_cut(1.0000001)).toBe(1);
    });

    test("should clamp 1.1 to 1", () => {
      expect(gemm.sin_cos_cut(1.1)).toBe(1);
    });

    test("should clamp 2 to 1", () => {
      expect(gemm.sin_cos_cut(2)).toBe(1);
    });

    test("should clamp 100 to 1", () => {
      expect(gemm.sin_cos_cut(100)).toBe(1);
    });

    test("should clamp -1.00000000001 to -1", () => {
      expect(gemm.sin_cos_cut(-1.00000000001)).toBe(-1);
    });

    test("should clamp -1.0000001 to -1", () => {
      expect(gemm.sin_cos_cut(-1.0000001)).toBe(-1);
    });

    test("should clamp -1.1 to -1", () => {
      expect(gemm.sin_cos_cut(-1.1)).toBe(-1);
    });

    test("should clamp -2 to -1", () => {
      expect(gemm.sin_cos_cut(-2)).toBe(-1);
    });

    test("should clamp -100 to -1", () => {
      expect(gemm.sin_cos_cut(-100)).toBe(-1);
    });
  });

  describe("Edge cases and precision errors", () => {
    test("should handle tiny positive overflow", () => {
      expect(gemm.sin_cos_cut(1 + Number.EPSILON)).toBe(1);
    });

    test("should handle tiny negative overflow", () => {
      expect(gemm.sin_cos_cut(-1 - Number.EPSILON)).toBe(-1);
    });

    test("should handle very small positive number", () => {
      expect(gemm.sin_cos_cut(0.0000001)).toBe(0.0000001);
    });

    test("should handle very small negative number", () => {
      expect(gemm.sin_cos_cut(-0.0000001)).toBe(-0.0000001);
    });

    test("should handle Infinity by clamping to 1", () => {
      expect(gemm.sin_cos_cut(Infinity)).toBe(1);
    });

    test("should handle negative Infinity by clamping to -1", () => {
      expect(gemm.sin_cos_cut(-Infinity)).toBe(-1);
    });
  });

  describe("Real-world sin/cos precision cases", () => {
    test("should handle sin(π/2) with floating-point error", () => {
      const sinPiHalf = Math.sin(Math.PI / 2); // Often slightly > 1
      const result = gemm.sin_cos_cut(sinPiHalf);
      expect(result).toBeLessThanOrEqual(1);
      expect(result).toBeGreaterThanOrEqual(0.999999);
    });

    test("should handle cos(0) with floating-point error", () => {
      const cosZero = Math.cos(0); // Should be exactly 1
      const result = gemm.sin_cos_cut(cosZero);
      expect(result).toBe(1);
    });

    test("should handle cos(π) with floating-point error", () => {
      const cosPi = Math.cos(Math.PI); // Often slightly < -1
      const result = gemm.sin_cos_cut(cosPi);
      expect(result).toBeLessThanOrEqual(-0.999999);
      expect(result).toBeGreaterThanOrEqual(-1);
    });
  });
});

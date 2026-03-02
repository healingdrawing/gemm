// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXD function using Bun's built-in test runner
 * Tests vector calculation between two points in n-dimensional space
 */

describe("vecXD", () => {
  describe("Basic vector calculation", () => {
    test("should calculate vector for two 2D points", () => {
      const dotA = [1, 2];
      const dotB = [4, 6];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([3, 4]);
    });

    test("should calculate vector for two 3D points", () => {
      const dotA = [1, 2, 3];
      const dotB = [4, 5, 6];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([3, 3, 3]);
    });

    test("should calculate vector for two 4D points", () => {
      const dotA = [0, 0, 0, 0];
      const dotB = [1, 2, 3, 4];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([1, 2, 3, 4]);
    });

    test("should calculate vector for high-dimensional points", () => {
      const dotA = [1, 1, 1, 1, 1];
      const dotB = [2, 3, 4, 5, 6];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([1, 2, 3, 4, 5]);
    });
  });

  describe("Negative values and direction", () => {
    test("should handle negative coordinates in start point", () => {
      const dotA = [-1, -2];
      const dotB = [1, 2];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([2, 4]);
    });

    test("should handle negative coordinates in end point", () => {
      const dotA = [1, 2];
      const dotB = [-1, -2];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([-2, -4]);
    });

    test("should handle both points with negative coordinates", () => {
      const dotA = [-5, -3];
      const dotB = [-2, -1];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([3, 2]);
    });

    test("should produce negative vector when start is ahead of end", () => {
      const dotA = [5, 5];
      const dotB = [2, 3];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([-3, -2]);
    });

    test("should handle mixed positive and negative coordinates", () => {
      const dotA = [-1, 2, -3];
      const dotB = [1, -2, 3];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([2, -4, 6]);
    });
  });

  describe("Zero vectors and same points", () => {
    test("should return zero vector when both points are identical", () => {
      const dotA = [1, 2, 3];
      const dotB = [1, 2, 3];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([0, 0, 0]);
    });

    test("should return zero vector for identical 2D points", () => {
      const dotA = [5, 5];
      const dotB = [5, 5];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([0, 0]);
    });

    test("should calculate from origin correctly", () => {
      const dotA = [0, 0, 0];
      const dotB = [3, 4, 5];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([3, 4, 5]);
    });

    test("should calculate to origin correctly", () => {
      const dotA = [3, 4, 5];
      const dotB = [0, 0, 0];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([-3, -4, -5]);
    });
  });

  describe("Decimal and floating-point values", () => {
    test("should handle decimal coordinates", () => {
      const dotA = [1.5, 2.5];
      const dotB = [4.5, 6.5];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([3, 4]);
    });

    test("should handle very small decimal differences", () => {
      const dotA = [0.1, 0.2];
      const dotB = [0.3, 0.4];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBeCloseTo(0.2);
      expect(result[1]).toBeCloseTo(0.2);
    });

    test("should handle mixed integer and decimal values", () => {
      const dotA = [1, 2.5, 3];
      const dotB = [4.5, 5, 6.5];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBeCloseTo(3.5);
      expect(result[1]).toBeCloseTo(2.5);
      expect(result[2]).toBeCloseTo(3.5);
    });

    test("should handle very large numbers", () => {
      const dotA = [1e10, 2e10];
      const dotB = [3e10, 5e10];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBeCloseTo(2e10);
      expect(result[1]).toBeCloseTo(3e10);
    });

    test("should handle very small numbers", () => {
      const dotA = [1e-10, 2e-10];
      const dotB = [3e-10, 5e-10];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBeCloseTo(2e-10);
      expect(result[1]).toBeCloseTo(3e-10);
    });
  });

  describe("Mismatched array lengths", () => {
    test("should return empty array when arrays have different lengths", () => {
      const dotA = [1, 2, 3];
      const dotB = [4, 5];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([]);
    });

    test("should return empty array when start point is longer", () => {
      const dotA = [1, 2, 3, 4];
      const dotB = [5, 6, 7];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([]);
    });

    test("should return empty array when end point is longer", () => {
      const dotA = [1, 2];
      const dotB = [3, 4, 5, 6];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([]);
    });

    test("should return empty array for significant length mismatch", () => {
      const dotA = [1, 2, 3];
      const dotB = [4, 5, 6, 7, 8, 9, 10];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([]);
    });

    test("should return empty array when one point is empty", () => {
      const dotA: Array<number> = [];
      const dotB = [1, 2, 3];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([]);
    });

    test("should return empty array when both points are empty", () => {
      const dotA: Array<number> = [];
      const dotB: Array<number> = [];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([]);
    });
  });

  describe("Edge cases - single dimension", () => {
    test("should calculate 1D vector", () => {
      const dotA = [5];
      const dotB = [10];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([5]);
    });

    test("should handle 1D vector with negative result", () => {
      const dotA = [10];
      const dotB = [3];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([-7]);
    });

    test("should handle 1D vector with zero result", () => {
      const dotA = [7];
      const dotB = [7];
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual([0]);
    });
  });

  describe("High-dimensional spaces", () => {
    test("should calculate vector in 10D space", () => {
      const dotA = Array(10).fill(1);
      const dotB = Array(10).fill(3);
      const result = gemm.vecXD(dotA, dotB);
      expect(result).toEqual(Array(10).fill(2));
    });

    test("should calculate vector in 100D space", () => {
      const dotA = Array(100).fill(0);
      const dotB = Array(100).fill(1);
      const result = gemm.vecXD(dotA, dotB);
      expect(result.length).toBe(100);
      expect(result.every(val => val === 1)).toBe(true);
    });

    test("should handle high-dimensional space with varied values", () => {
      const dotA = Array(50).fill(0).map((_, i) => i);
      const dotB = Array(50).fill(0).map((_, i) => i * 2);
      const result = gemm.vecXD(dotA, dotB);
      expect(result.length).toBe(50);
      expect(result.every((val, i) => val === i)).toBe(true);
    });
  });

  describe("Numeric precision", () => {
    test("should maintain precision with repeated calculations", () => {
      const dotA = [0.1, 0.2, 0.3];
      const dotB = [0.4, 0.5, 0.6];
      const result = gemm.vecXD(dotA, dotB);
      expect(result.length).toBe(3);
      expect(result[0]).toBeCloseTo(0.3);
      expect(result[1]).toBeCloseTo(0.3);
      expect(result[2]).toBeCloseTo(0.3);
    });

    test("should handle accumulation of small floating-point errors", () => {
      const dotA = [0.1 + 0.2, 0.3];
      const dotB = [0.6, 0.9];
      const result = gemm.vecXD(dotA, dotB);
      expect(result.length).toBe(2);
      expect(result[0]).toBeCloseTo(0.3);
      expect(result[1]).toBeCloseTo(0.6);
    });
  });

  describe("Special numeric values", () => {
    test("should handle Infinity values", () => {
      const dotA = [1, 2];
      const dotB = [Infinity, Infinity];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBe(Infinity);
      expect(result[1]).toBe(Infinity);
    });

    test("should handle negative Infinity values", () => {
      const dotA = [1, 2];
      const dotB = [-Infinity, -Infinity];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBe(-Infinity);
      expect(result[1]).toBe(-Infinity);
    });

    test("should handle NaN values", () => {
      const dotA = [1, 2];
      const dotB = [NaN, 5];
      const result = gemm.vecXD(dotA, dotB);
      expect(Number.isNaN(result[0])).toBe(true);
      expect(result[1]).toBe(3);
    });

    test("should handle mixed special values", () => {
      const dotA = [0, 1, 2];
      const dotB = [Infinity, NaN, -Infinity];
      const result = gemm.vecXD(dotA, dotB);
      expect(result[0]).toBe(Infinity);
      expect(Number.isNaN(result[1])).toBe(true);
      expect(result[2]).toBe(-Infinity);
    });
  });

  describe("Return value characteristics", () => {
    test("should return array type", () => {
      const dotA = [1, 2];
      const dotB = [3, 4];
      const result = gemm.vecXD(dotA, dotB);
      expect(Array.isArray(result)).toBe(true);
    });

    test("should return array with correct length on success", () => {
      const dotA = [1, 2, 3, 4, 5];
      const dotB = [6, 7, 8, 9, 10];
      const result = gemm.vecXD(dotA, dotB);
      expect(result.length).toBe(5);
    });

    test("should return empty array on length mismatch", () => {
      const dotA = [1, 2];
      const dotB = [3, 4, 5];
      const result = gemm.vecXD(dotA, dotB);
      expect(Array.isArray(result)).toBe(true);
      expect(result.length).toBe(0);
    });

    test("should not modify input arrays", () => {
      const dotA = [1, 2, 3];
      const dotB = [4, 5, 6];
      const dotACopy = [...dotA];
      const dotBCopy = [...dotB];
      gemm.vecXD(dotA, dotB);
      expect(dotA).toEqual(dotACopy);
      expect(dotB).toEqual(dotBCopy);
    });
  });

  describe("Mathematical properties", () => {
    test("should satisfy vector reversal property: vecXD(A,B) = -vecXD(B,A)", () => {
      const dotA = [1, 2, 3];
      const dotB = [4, 5, 6];
      const vec1 = gemm.vecXD(dotA, dotB);
      const vec2 = gemm.vecXD(dotB, dotA);
      expect(vec1.map(v => -v)).toEqual(vec2);
    });

    test("should satisfy zero vector property: vecXD(A,A) = [0,0,...,0]", () => {
      const dot = [3, 7, -2, 5];
      const result = gemm.vecXD(dot, dot);
      expect(result.every(val => val === 0)).toBe(true);
    });

    test("should satisfy transitivity: vecXD(A,C) = vecXD(A,B) + vecXD(B,C)", () => {
      const dotA = [1, 1];
      const dotB = [3, 4];
      const dotC = [5, 8];
      const vec_AC = gemm.vecXD(dotA, dotC);
      const vec_AB = gemm.vecXD(dotA, dotB);
      const vec_BC = gemm.vecXD(dotB, dotC);
      expect(vec_AC[0]).toBeCloseTo(vec_AB[0] + vec_BC[0]);
      expect(vec_AC[1]).toBeCloseTo(vec_AB[1] + vec_BC[1]);
    });
  });
});

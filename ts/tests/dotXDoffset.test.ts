// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for dotXDoffset function using Bun's built-in test runner
 * Tests offsetting a point along a vector by a given distance in n-dimensional space
 */

describe("dotXDoffset", () => {
  describe("Basic offset calculation", () => {
    test("should offset 2D point [0,0] along vector [1,0] by distance 5", () => {
      const dot = [0, 0];
      const vec = [1, 0];
      const result = gemm.dotXDoffset(dot, vec, 5);
      expect(result).toEqual([5, 0]);
    });

    test("should offset 2D point [1,1] along vector [3,4] by distance 5", () => {
      const dot = [1, 1];
      const vec = [3, 4]; // norm = 5
      const result = gemm.dotXDoffset(dot, vec, 5);
      expect(result[0]).toBeCloseTo(4); // 1 + 3
      expect(result[1]).toBeCloseTo(5); // 1 + 4
    });

    test("should offset 3D point [1,2,2] along vector [1,2,2] by distance 3", () => {
      const dot = [1, 2, 2];
      const vec = [1, 2, 2]; // norm = 3
      const result = gemm.dotXDoffset(dot, vec, 3);
      expect(result[0]).toBeCloseTo(2); // 1 + 1
      expect(result[1]).toBeCloseTo(4); // 2 + 2
      expect(result[2]).toBeCloseTo(4); // 2 + 2
    });

    test("should offset point along normalized unit vector [1,0]", () => {
      const dot = [0, 0];
      const vec = [2, 0]; // norm = 2, will normalize
      const result = gemm.dotXDoffset(dot, vec, 10);
      expect(result[0]).toBeCloseTo(10); // offset by 10 in normalized direction
      expect(result[1]).toBeCloseTo(0);
    });

    test("should offset 4D point along 4D vector", () => {
      const dot = [1, 1, 1, 1];
      const vec = [1, 1, 1, 1]; // norm = 2
      const result = gemm.dotXDoffset(dot, vec, 2);
      expect(result[0]).toBeCloseTo(2);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(2);
      expect(result[3]).toBeCloseTo(2);
    });
  });

  describe("Edge cases and zero values", () => {
    test("should return original point when t is 0", () => {
      const dot = [3, 4];
      const vec = [1, 0];
      const result = gemm.dotXDoffset(dot, vec, 0);
      expect(result).toEqual([3, 4]);
    });

    test("should return original point when vector is zero vector", () => {
      const dot = [5, 5];
      const vec = [0, 0];
      const result = gemm.dotXDoffset(dot, vec, 10);
      expect(result).toEqual([5, 5]);
    });

    test("should return original point when both t and vector are zero", () => {
      const dot = [2, 3];
      const vec = [0, 0];
      const result = gemm.dotXDoffset(dot, vec, 0);
      expect(result).toEqual([2, 3]);
    });

    test("should handle negative offset distance", () => {
      const dot = [10, 10];
      const vec = [1, 0]; // norm = 1
      const result = gemm.dotXDoffset(dot, vec, -5);
      expect(result[0]).toBeCloseTo(5); // 10 - 5
      expect(result[1]).toBeCloseTo(10);
    });

    test("should return original point when dimensions don't match", () => {
      const dot = [1, 2];
      const vec = [1, 2, 3];
      const result = gemm.dotXDoffset(dot, vec, 5);
      expect(result).toEqual([1, 2]);
    });
  });

  describe("Negative vector components", () => {
    test("should offset along vector with negative components", () => {
      const dot = [5, 5];
      const vec = [-3, -4]; // norm = 5
      const result = gemm.dotXDoffset(dot, vec, 5);
      expect(result[0]).toBeCloseTo(2); // 5 - 3
      expect(result[1]).toBeCloseTo(1); // 5 - 4
    });

    test("should offset along mixed sign vector", () => {
      const dot = [0, 0];
      const vec = [3, -4]; // norm = 5
      const result = gemm.dotXDoffset(dot, vec, 10);
      expect(result[0]).toBeCloseTo(6); // 0 + 3 * 2
      expect(result[1]).toBeCloseTo(-8); // 0 - 4 * 2
    });
  });

  describe("Large dimensions", () => {
    test("should offset point in 5D space", () => {
      const dot = [1, 1, 1, 1, 1];
      const vec = [1, 0, 0, 0, 0]; // norm = 1
      const result = gemm.dotXDoffset(dot, vec, 3);
      expect(result).toEqual([4, 1, 1, 1, 1]);
    });

    test("should offset point in 6D space with mixed values", () => {
      const dot = [0, 0, 0, 0, 0, 0];
      const vec = [1, 1, 1, 1, 1, 1]; // norm = sqrt(6)
      const result = gemm.dotXDoffset(dot, vec, Math.sqrt(6));
      for (let i = 0; i < 6; i++) {
        expect(result[i]).toBeCloseTo(1);
      }
    });
  });

  describe("Floating point precision", () => {
    test("should handle small offset distances accurately", () => {
      const dot = [0, 0];
      const vec = [1, 0];
      const result = gemm.dotXDoffset(dot, vec, 0.0001);
      expect(result[0]).toBeCloseTo(0.0001);
      expect(result[1]).toBeCloseTo(0);
    });

    test("should handle very large offset distances", () => {
      const dot = [0, 0];
      const vec = [1, 0];
      const result = gemm.dotXDoffset(dot, vec, 1000000);
      expect(result[0]).toBeCloseTo(1000000);
      expect(result[1]).toBeCloseTo(0);
    });
  });
});

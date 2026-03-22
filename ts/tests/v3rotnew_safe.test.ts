// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3rotnew_safe function using Bun's built-in test runner
 * Tests 3D vector rotation around an arbitrary axis with safety checks
 */

describe("v3rotnew_safe", () => {
  describe("Valid rotations", () => {
    test("should rotate vector 90 degrees around z-axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector 180 degrees around z-axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(-1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector 90 degrees around x-axis", () => {
      const v = new Float32Array([0, 1, 0]);
      const naxis = new Float32Array([1, 0, 0]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(1, 5);
    });

    test("should rotate vector 90 degrees around y-axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 1, 0]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(-1, 5);
    });

    test("should rotate vector around arbitrary normalized axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([1, 1, 0]);
      gemm.v3one(naxis);
      const angle = Math.PI / 4;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      const mag = Math.sqrt(result[0]*result[0] + result[1]*result[1] + result[2]*result[2]);
      expect(mag).toBeCloseTo(1, 5);
    });

    test("should preserve vector magnitude after rotation", () => {
      const v = new Float32Array([3, 4, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 3;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      const origMag = Math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
      const resultMag = Math.sqrt(result[0]*result[0] + result[1]*result[1] + result[2]*result[2]);
      expect(resultMag).toBeCloseTo(origMag, 5);
    });

    test("should rotate by zero angle (identity rotation)", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = 0;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(v[0], 5);
      expect(result[1]).toBeCloseTo(v[1], 5);
      expect(result[2]).toBeCloseTo(v[2], 5);
    });

    test("should handle non-normalized axis (normalizes internally)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 5]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should handle negative angle (counter-clockwise rotation)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = -Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(-1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should handle large angle (full rotations)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI * 4;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should handle very small angle", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = 1e-8;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });
  });

  describe("Invalid inputs - returns copy of original v", () => {
    test("should return copy of v when v is zero vector", () => {
      const v = new Float32Array([0, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(0);
      expect(result[1]).toBe(0);
      expect(result[2]).toBe(0);
    });

    test("should return copy of v when v contains NaN", () => {
      const v = new Float32Array([NaN, 1, 1]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(Number.isNaN(result[0])).toBe(true);
      expect(result[1]).toBe(1);
      expect(result[2]).toBe(1);
    });

    test("should return copy of v when v contains Infinity", () => {
      const v = new Float32Array([Infinity, 1, 1]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(Infinity);
      expect(result[1]).toBe(1);
      expect(result[2]).toBe(1);
    });

    test("should return copy of v when naxis is zero vector", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 0, 0]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
      expect(result[2]).toBe(v[2]);
    });

    test("should return copy of v when naxis contains NaN", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([NaN, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
      expect(result[2]).toBe(v[2]);
    });

    test("should return copy of v when naxis contains Infinity", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, Infinity]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
      expect(result[2]).toBe(v[2]);
    });

    test("should return copy of v when angle is NaN", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = NaN;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
      expect(result[2]).toBe(v[2]);
    });

    test("should return copy of v when angle is Infinity", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Infinity;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
      expect(result[2]).toBe(v[2]);
    });

    test("should return copy of v when v has wrong length", () => {
      const v = new Float32Array([1, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result.length).toBe(v.length);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
    });

    test("should return copy of v when naxis has wrong length", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(result[0]).toBe(v[0]);
      expect(result[1]).toBe(v[1]);
      expect(result[2]).toBe(v[2]);
    });
  });

  describe("Return value properties", () => {
    test("should always return new Float32Array (not mutate input)", () => {
      const v = new Float32Array([1, 0, 0]);
      const vOriginal = new Float32Array(v);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result).not.toBe(v);
      expect(v[0]).toBe(vOriginal[0]);
      expect(v[1]).toBe(vOriginal[1]);
      expect(v[2]).toBe(vOriginal[2]);
    });

    test("should always return Float32Array with length 3", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 4;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result instanceof Float32Array).toBe(true);
      expect(result.length).toBe(3);
    });
  });

  describe("Rodrigues rotation formula verification", () => {
    test("should correctly rotate vector parallel to axis (should not change)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([1, 0, 0]);
      const angle = Math.PI / 3;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should correctly rotate vector perpendicular to axis", () => {
      const v = new Float32Array([0, 1, 0]);
      const naxis = new Float32Array([1, 0, 0]);
      const angle = Math.PI / 2;

      const result = gemm.v3rotnew_safe(v, naxis, angle);

      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(1, 5);
    });

    test("should maintain orthogonality after rotation", () => {
      const v1 = new Float32Array([1, 0, 0]);
      const v2 = new Float32Array([0, 1, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const angle = Math.PI / 4;

      const r1 = gemm.v3rotnew_safe(v1, naxis, angle);
      const r2 = gemm.v3rotnew_safe(v2, naxis, angle);

      const dotProduct = r1[0]*r2[0] + r1[1]*r2[1] + r1[2]*r2[2];
      expect(dotProduct).toBeCloseTo(0, 5);
    });
  });
});

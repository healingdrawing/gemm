// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3rotmut_safe function using Bun's built-in test runner
 * Tests safe 3D vector rotation with input validation and normalization checks
 * Silently does nothing if any checks fail
 */

describe("v3rotmut_safe", () => {
  describe("Valid rotations", () => {
    test("should rotate vector 90° around Z axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBeCloseTo(0, 5);
      expect(v[1]).toBeCloseTo(1, 5);
      expect(v[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector 90° around X axis", () => {
      const v = new Float32Array([0, 1, 0]);
      const naxis = new Float32Array([1, 0, 0]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBeCloseTo(0, 5);
      expect(v[1]).toBeCloseTo(0, 5);
      expect(v[2]).toBeCloseTo(1, 5);
    });

    test("should rotate zero vector (stays zero)", () => {
      const v = new Float32Array([0, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(0);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });

    test("should not change vector when angle is 0", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, 0);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(2);
      expect(v[2]).toBe(3);
    });

    test("should rotate around normalized arbitrary axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([1, 1, 1]);
      const len = Math.sqrt(3);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      gemm.v3rotmut_safe(v, naxis, Math.PI * 2 / 3);
      expect(v[0]).toBeCloseTo(0, 4);
      expect(v[1]).toBeCloseTo(1, 4);
      expect(v[2]).toBeCloseTo(0, 4);
    });
  });

  describe("Invalid angle (NaN/Infinity)", () => {
    test("should silently do nothing when angle is NaN", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, NaN);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });

    test("should silently do nothing when angle is Infinity", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Infinity);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });

    test("should silently do nothing when angle is -Infinity", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, -Infinity);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });
  });

  describe("Invalid vector dimensions", () => {
    test("should silently do nothing when v has wrong length (2)", () => {
      const v = new Float32Array([1, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
    });

    test("should silently do nothing when v has wrong length (4)", () => {
      const v = new Float32Array([1, 0, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
      expect(v[3]).toBe(0);
    });
  });

  describe("Invalid axis dimensions", () => {
    test("should silently do nothing when naxis has wrong length (2)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });

    test("should silently do nothing when naxis has wrong length (4)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1, 0]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });
  });

  describe("Invalid vector values (NaN/Infinity)", () => {
    test("should silently do nothing when v contains NaN", () => {
      const v = new Float32Array([NaN, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(Number.isNaN(v[0])).toBe(true);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });

    test("should silently do nothing when v contains Infinity", () => {
      const v = new Float32Array([1, Infinity, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(Infinity);
      expect(v[2]).toBe(0);
    });

    test("should silently do nothing when v contains -Infinity", () => {
      const v = new Float32Array([1, 0, -Infinity]);
      const naxis = new Float32Array([0, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(-Infinity);
    });
  });

  describe("Invalid axis values (NaN/Infinity)", () => {
    test("should silently do nothing when naxis contains NaN", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([NaN, 0, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });

    test("should silently do nothing when naxis contains Infinity", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, Infinity, 1]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });
  });

  describe("Zero axis vector", () => {
    test("should silently do nothing when naxis is zero vector [0,0,0]", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 0]);
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      expect(v[0]).toBe(1);
      expect(v[1]).toBe(0);
      expect(v[2]).toBe(0);
    });
  });

  describe("Non-normalized axis", () => {
    test("should accept axis with magnitude very close to 1 (within tolerance)", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1.005]); // magnitude 1.005, within tolerance
      gemm.v3rotmut_safe(v, naxis, Math.PI / 2);
      // Should perform rotation (magnitude within tolerance)
      expect(v[1]).toBeGreaterThan(0); // y should be non-zero after rotation
    });
  });

  describe("Magnitude preservation on valid rotations", () => {
    test("should preserve vector magnitude after safe rotation", () => {
      const v = new Float32Array([3, 4, 5]);
      const originalMag = Math.sqrt(3*3 + 4*4 + 5*5);
      const naxis = new Float32Array([1, 2, 3]);
      const len = Math.sqrt(1 + 4 + 9);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      gemm.v3rotmut_safe(v, naxis, Math.PI / 3);
      const newMag = Math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
      expect(newMag).toBeCloseTo(originalMag, 4);
    });
  });

});

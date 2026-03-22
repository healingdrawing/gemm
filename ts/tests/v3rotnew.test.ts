// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for v3rotnew function using Bun's built-in test runner
 * Tests 3D vector rotation around a normalized axis
 * Returns a new rotated vector without mutating the input
 */

describe("v3rotnew", () => {
  describe("Basic rotations around cardinal axes", () => {
    test("should rotate vector 90° around Z axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]); // Z axis
      const result = gemm.v3rotnew(v, naxis, Math.PI / 2); // 90°
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector 90° around X axis", () => {
      const v = new Float32Array([0, 1, 0]);
      const naxis = new Float32Array([1, 0, 0]); // X axis
      const result = gemm.v3rotnew(v, naxis, Math.PI / 2); // 90°
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(1, 5);
    });

    test("should rotate vector 90° around Y axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 1, 0]); // Y axis
      const result = gemm.v3rotnew(v, naxis, Math.PI / 2); // 90°
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(-1, 5);
    });
  });

  describe("Full rotations", () => {
    test("should return to original vector after 360° rotation", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([1, 1, 1]);
      // Normalize axis
      const len = Math.sqrt(1 + 1 + 1);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      const result = gemm.v3rotnew(v, naxis, Math.PI * 2); // 360°
      expect(result[0]).toBeCloseTo(1, 4);
      expect(result[1]).toBeCloseTo(2, 4);
      expect(result[2]).toBeCloseTo(3, 4);
    });

    test("should return to original vector after 180° + 180° rotations", () => {
      const v = new Float32Array([3, 4, 5]);
      const naxis = new Float32Array([0, 0, 1]);
      
      let result = gemm.v3rotnew(v, naxis, Math.PI); // 180°
      result = gemm.v3rotnew(result, naxis, Math.PI); // 180°
      expect(result[0]).toBeCloseTo(3, 4);
      expect(result[1]).toBeCloseTo(4, 4);
      expect(result[2]).toBeCloseTo(5, 4);
    });
  });

  describe("Zero and identity rotations", () => {
    test("should not change vector when angle is 0", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 0, 1]);
      const result = gemm.v3rotnew(v, naxis, 0); // 0°
      expect(result[0]).toBe(1);
      expect(result[1]).toBe(2);
      expect(result[2]).toBe(3);
    });

    test("should not change vector when rotating zero vector", () => {
      const v = new Float32Array([0, 0, 0]);
      const naxis = new Float32Array([1, 0, 0]);
      const result = gemm.v3rotnew(v, naxis, Math.PI / 2);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should not change vector parallel to rotation axis", () => {
      const v = new Float32Array([5, 0, 0]);
      const naxis = new Float32Array([1, 0, 0]); // Parallel to v
      const result = gemm.v3rotnew(v, naxis, Math.PI / 4); // 45°
      expect(result[0]).toBeCloseTo(5, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });
  });

  describe("Magnitude preservation", () => {
    test("should preserve vector magnitude after rotation", () => {
      const v = new Float32Array([3, 4, 5]);
      const originalMag = Math.sqrt(3*3 + 4*4 + 5*5);
      const naxis = new Float32Array([1, 2, 3]);
      const len = Math.sqrt(1 + 4 + 9);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      const result = gemm.v3rotnew(v, naxis, Math.PI / 3); // 60°
      const newMag = Math.sqrt(result[0]*result[0] + result[1]*result[1] + result[2]*result[2]);
      expect(newMag).toBeCloseTo(originalMag, 4);
    });

    test("should preserve unit vector magnitude", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 1, 1]);
      const len = Math.sqrt(2);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      const result = gemm.v3rotnew(v, naxis, Math.PI / 6); // 30°
      const mag = Math.sqrt(result[0]*result[0] + result[1]*result[1] + result[2]*result[2]);
      expect(mag).toBeCloseTo(1, 5);
    });
  });

  describe("Negative angles and directions", () => {
    test("should rotate opposite direction with negative angle", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      
      const result1 = gemm.v3rotnew(v, naxis, Math.PI / 4); // 45°
      const result2 = gemm.v3rotnew(v, naxis, -Math.PI / 4); // -45°
      
      expect(result1[0]).toBeCloseTo(result2[0], 5);
      expect(result1[1]).toBeCloseTo(-result2[1], 5);
      expect(result1[2]).toBeCloseTo(result2[2], 5);
    });
  });

  describe("Arbitrary axis rotations", () => {
    test("should rotate around arbitrary normalized axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([1, 1, 1]);
      const len = Math.sqrt(3);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      const result = gemm.v3rotnew(v, naxis, Math.PI * 2 / 3); // 120°
      // After 120° rotation around [1,1,1], [1,0,0] should map to [0,1,0]
      expect(result[0]).toBeCloseTo(0, 4);
      expect(result[1]).toBeCloseTo(1, 4);
      expect(result[2]).toBeCloseTo(0, 4);
    });

    test("should rotate [0,1,0] around [1,1,1] axis by 120°", () => {
      const v = new Float32Array([0, 1, 0]);
      const naxis = new Float32Array([1, 1, 1]);
      const len = Math.sqrt(3);
      naxis[0] /= len;
      naxis[1] /= len;
      naxis[2] /= len;
      
      const result = gemm.v3rotnew(v, naxis, Math.PI * 2 / 3); // 120°
      // After 120° rotation around [1,1,1], [0,1,0] should map to [0,0,1]
      expect(result[0]).toBeCloseTo(0, 4);
      expect(result[1]).toBeCloseTo(0, 4);
      expect(result[2]).toBeCloseTo(1, 4);
    });
  });

  describe("Input immutability", () => {
    test("should not mutate original input vector", () => {
      const v = new Float32Array([1, 0, 0]);
      const originalV0 = v[0];
      const originalV1 = v[1];
      const originalV2 = v[2];
      const naxis = new Float32Array([0, 0, 1]);
      
      gemm.v3rotnew(v, naxis, Math.PI / 2);
      
      expect(v[0]).toBe(originalV0);
      expect(v[1]).toBe(originalV1);
      expect(v[2]).toBe(originalV2);
    });

    test("should not mutate original input axis", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const originalAxis0 = naxis[0];
      const originalAxis1 = naxis[1];
      const originalAxis2 = naxis[2];
      
      gemm.v3rotnew(v, naxis, Math.PI / 2);
      
      expect(naxis[0]).toBe(originalAxis0);
      expect(naxis[1]).toBe(originalAxis1);
      expect(naxis[2]).toBe(originalAxis2);
    });
  });

  describe("Return value type and properties", () => {
    test("should return a new Float32Array", () => {
      const v = new Float32Array([1, 0, 0]);
      const naxis = new Float32Array([0, 0, 1]);
      const result = gemm.v3rotnew(v, naxis, Math.PI / 2);
      
      expect(result).toBeInstanceOf(Float32Array);
      expect(result).not.toBe(v); // Different reference
    });

    test("should return array with exactly 3 elements", () => {
      const v = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 0, 1]);
      const result = gemm.v3rotnew(v, naxis, Math.PI / 2);
      
      expect(result.length).toBe(3);
    });
  });

  describe("Consistency with v3rotmut", () => {
    test("should produce same result as v3rotmut", () => {
      const v1 = new Float32Array([1, 2, 3]);
      const v2 = new Float32Array([1, 2, 3]);
      const naxis = new Float32Array([0, 1, 0]);
      
      const result = gemm.v3rotnew(v1, naxis, Math.PI / 3);
      gemm.v3rotmut(v2, naxis, Math.PI / 3);
      
      expect(result[0]).toBeCloseTo(v2[0], 5);
      expect(result[1]).toBeCloseTo(v2[1], 5);
      expect(result[2]).toBeCloseTo(v2[2], 5);
    });
  });

});

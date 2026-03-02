// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vec3Drotate function using Bun's built-in test runner
 * Tests 3D vector rotation around an arbitrary axis by a specified angle
 */

describe("vec3Drotate", () => {
  describe("Basic rotation around cardinal axes", () => {
    test("should rotate vector [1,0,0] around Z-axis by 90 degrees", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, 90);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector [0,1,0] around X-axis by 90 degrees", () => {
      const vec = [0, 1, 0];
      const axis = [1, 0, 0];
      const result = gemm.vec3Drotate(vec, axis, 90);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(1, 5);
    });

    test("should rotate vector [0,0,1] around Y-axis by 90 degrees", () => {
      const vec = [0, 0, 1];
      const axis = [0, 1, 0];
      const result = gemm.vec3Drotate(vec, axis, 90);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector [1,0,0] around Z-axis by 180 degrees", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, 180);
      expect(result[0]).toBeCloseTo(-1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector [1,1,0] around Z-axis by 45 degrees", () => {
      const vec = [1, 1, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, 45);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(Math.sqrt(2), 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });
  });

  describe("Rotation with radians", () => {
    test("should rotate vector [1,0,0] around Z-axis by π/2 radians", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, Math.PI / 2, true);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector [0,1,0] around X-axis by π radians", () => {
      const vec = [0, 1, 0];
      const axis = [1, 0, 0];
      const result = gemm.vec3Drotate(vec, axis, Math.PI, true);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(-1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector [1,0,0] around Z-axis by π/4 radians", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, Math.PI / 4, true);
      expect(result[0]).toBeCloseTo(Math.sqrt(2) / 2, 5);
      expect(result[1]).toBeCloseTo(Math.sqrt(2) / 2, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });
  });

  describe("Edge cases - zero rotation", () => {
    test("should return original vector when angle is 0", () => {
      const vec = [1, 2, 3];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, 0);
      expect(result).toEqual([1, 2, 3]);
    });

    test("should return original vector when angle is 0 radians", () => {
      const vec = [3, 4, 5];
      const axis = [1, 0, 0];
      const result = gemm.vec3Drotate(vec, axis, 0, true);
      expect(result).toEqual([3, 4, 5]);
    });

    test("should return original vector when vector is parallel to axis", () => {
      const vec = [2, 0, 0];
      const axis = [1, 0, 0];
      const result = gemm.vec3Drotate(vec, axis, 90);
      expect(result).toEqual([2, 0, 0]);
    });

    test("should return original vector when vector is parallel to axis (opposite direction)", () => {
      const vec = [-3, 0, 0];
      const axis = [1, 0, 0];
      const result = gemm.vec3Drotate(vec, axis, 45);
      expect(result).toEqual([-3, 0, 0]);
    });
  });

  describe("Full rotation cycles", () => {
    test("should return to original vector after 360 degree rotation", () => {
      const vec = [1, 2, 3];
      const axis = [1, 1, 1];
      const result = gemm.vec3Drotate(vec, axis, 360);
      expect(result[0]).toBeCloseTo(vec[0], 4);
      expect(result[1]).toBeCloseTo(vec[1], 4);
      expect(result[2]).toBeCloseTo(vec[2], 4);
    });

    test("should return to original vector after 2π radian rotation", () => {
      const vec = [2, 3, 4];
      const axis = [0, 1, 0];
      const result = gemm.vec3Drotate(vec, axis, 2 * Math.PI, true);
      expect(result[0]).toBeCloseTo(vec[0], 4);
      expect(result[1]).toBeCloseTo(vec[1], 4);
      expect(result[2]).toBeCloseTo(vec[2], 4);
    });

    test("should return to original vector after 720 degree rotation", () => {
      const vec = [1, 1, 1];
      const axis = [1, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, 720);
      expect(result[0]).toBeCloseTo(vec[0], 4);
      expect(result[1]).toBeCloseTo(vec[1], 4);
      expect(result[2]).toBeCloseTo(vec[2], 4);
    });
  });

  describe("Rotation around arbitrary axes", () => {
    test("should rotate vector around diagonal axis [1,1,1]", () => {
      const vec = [1, 0, 0];
      const axis = [1, 1, 1];
      const result = gemm.vec3Drotate(vec, axis, 120);
      expect(result[0]).toBeCloseTo(0, 4);
      expect(result[1]).toBeCloseTo(1, 4);
      expect(result[2]).toBeCloseTo(0, 4);
    });

    test("should rotate vector around arbitrary axis [1,2,3]", () => {
      const vec = [1, 0, 0];
      const axis = [1, 2, 3];
      const result = gemm.vec3Drotate(vec, axis, 90);
      // Verify vector magnitude is preserved
      const originalMag = Math.sqrt(1);
      const resultMag = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(resultMag).toBeCloseTo(originalMag, 4);
    });

    test("should rotate vector around axis [1,1,0]", () => {
      const vec = [1, 0, 0];
      const axis = [1, 1, 0];
      const result = gemm.vec3Drotate(vec, axis, 90);
      // Verify vector magnitude is preserved
      const originalMag = Math.sqrt(1);
      const resultMag = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(resultMag).toBeCloseTo(originalMag, 4);
    });
  });

  describe("Negative angles", () => {
    test("should rotate vector with negative angle (clockwise)", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, -90);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(-1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should rotate vector with negative angle (radians)", () => {
      const vec = [0, 1, 0];
      const axis = [1, 0, 0];
      const result = gemm.vec3Drotate(vec, axis, -Math.PI / 2, true);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(-1, 5);
    });
  });

  describe("Vector magnitude preservation", () => {
    test("should preserve magnitude of unit vector after rotation", () => {
      const vec = [1, 0, 0];
      const axis = [0, 1, 0];
      const result = gemm.vec3Drotate(vec, axis, 45);
      const resultMag = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(resultMag).toBeCloseTo(1, 4);
    });

    test("should preserve magnitude of arbitrary vector after rotation", () => {
      const vec = [3, 4, 5];
      const axis = [1, 1, 1];
      const originalMag = Math.sqrt(3 ** 2 + 4 ** 2 + 5 ** 2);
      const result = gemm.vec3Drotate(vec, axis, 60);
      const resultMag = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(resultMag).toBeCloseTo(originalMag, 4);
    });

    test("should preserve magnitude after multiple rotations", () => {
      let vec = [1, 2, 3];
      const axis = [0, 0, 1];
      const originalMag = Math.sqrt(1 ** 2 + 2 ** 2 + 3 ** 2);
      
      vec = gemm.vec3Drotate(vec, axis, 30);
      vec = gemm.vec3Drotate(vec, axis, 30);
      vec = gemm.vec3Drotate(vec, axis, 30);
      
      const resultMag = Math.sqrt(vec[0] ** 2 + vec[1] ** 2 + vec[2] ** 2);
      expect(resultMag).toBeCloseTo(originalMag, 4);
    });
  });

  describe("Small angle approximations", () => {
    test("should rotate vector by very small angle", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const angleInDegrees = 0.001;
      const result = gemm.vec3Drotate(vec, axis, angleInDegrees);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(Math.sin(angleInDegrees * Math.PI / 180), 5);
    });

    test("should rotate vector by very small angle (radians)", () => {
      const vec = [1, 0, 0];
      const axis = [0, 0, 1];
      const result = gemm.vec3Drotate(vec, axis, 0.0001, true);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0.0001, 5);
    });
  });

  describe("Normalized vs unnormalized axes", () => {
    test("should produce same result with normalized axis [0,0,1]", () => {
      const vec = [1, 0, 0];
      const axis1 = [0, 0, 1];
      const axis2 = [0, 0, 5]; // unnormalized
      const result1 = gemm.vec3Drotate(vec, axis1, 90);
      const result2 = gemm.vec3Drotate(vec, axis2, 90);
      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
    });
  });
});

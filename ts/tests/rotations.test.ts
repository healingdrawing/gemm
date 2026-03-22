// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Paired test suite for v3rotmut and vec3Drotate rotation functions
 * Both functions should produce identical results with same inputs (radians)
 * Vectors are normalized internally by the functions
 */

describe("Paired Rotation Functions", () => {
  
  describe("Rotate around Z-axis by 90° (π/2 radians)", () => {
    test("v3rotmut vs vec3Drotate should produce similar results", () => {
      const vector = [1, 0, 0];
      const axis = [0, 0, 1];
      const angle = Math.PI / 2;

      // Test v3rotmut
      const v1 = new Float32Array([1, 0, 0]);
      gemm.v3rotmut(v1, new Float32Array(axis), angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
    });
  });

  describe("Rotate around X-axis by 45° (π/4 radians)", () => {
    test("v3rotmut vs vec3Drotate should produce similar results", () => {
      const vector = [0, 1, 0];
      const axis = [1, 0, 0];
      const angle = Math.PI / 4;

      // Test v3rotmut
      const v1 = new Float32Array([0, 1, 0]);
      gemm.v3rotmut(v1, new Float32Array(axis), angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
    });
  });

  describe("Rotate around arbitrary normalized axis by 60° (π/3 radians)", () => {
    test("v3rotmut vs vec3Drotate should produce similar results", () => {
      const vector = [1, 2, 3];
      const axis = new Float32Array([1, 1, 1]); // Will be normalized internally only in v3rotmut_safe
      gemm.v3one(axis)
      const angle = Math.PI / 3;

      // Test v3rotmut
      const v1 = new Float32Array([1, 2, 3]);
      gemm.v3rotmut(v1, new Float32Array(axis), angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
    });
  });

  describe("Zero rotation (angle = 0)", () => {
    test("v3rotmut vs vec3Drotate should return original vector", () => {
      const vector = [3, 4, 5];
      const axis = [0, 1, 0];
      const angle = 0;

      // Test v3rotmut
      const v1 = new Float32Array([3, 4, 5]);
      gemm.v3rotmut(v1, new Float32Array(axis), angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
      expect(result1[0]).toBeCloseTo(3, 4);
      expect(result1[1]).toBeCloseTo(4, 4);
      expect(result1[2]).toBeCloseTo(5, 4);
    });
  });

  describe("Full rotation (angle = 2π radians)", () => {
    test("v3rotmut vs vec3Drotate should return original vector", () => {
      const vector = [2, 3, 4];
      const axis = [1, 2, 3]; // Will be normalized internally
      const angle = 2 * Math.PI;

      // Test v3rotmut
      const v1 = new Float32Array([2, 3, 4]);
      gemm.v3rotmut(v1, new Float32Array(axis), angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
      expect(result1[0]).toBeCloseTo(2, 4);
      expect(result1[1]).toBeCloseTo(3, 4);
      expect(result1[2]).toBeCloseTo(4, 4);
    });
  });

  describe("Rotate around Y-axis by 180° (π radians)", () => {
    test("v3rotmut vs vec3Drotate should produce similar results", () => {
      const vector = [1, 0, 0];
      const axis = [0, 1, 0];
      const angle = Math.PI;

      // Test v3rotmut
      const v1 = new Float32Array([1, 0, 0]);
      gemm.v3rotmut(v1, new Float32Array(axis), angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
    });
  });

  describe("Rotate arbitrary vector around arbitrary axis", () => {
    test("v3rotmut vs vec3Drotate should produce similar results", () => {
      const vector = [5, 7, 2];
      const axis = new Float32Array([2, 1, 3]);
      gemm.v3one(axis)
      const angle = Math.PI / 6; // 30°

      // Test v3rotmut
      const v1 = new Float32Array([5, 7, 2]);
      gemm.v3rotmut(v1, axis, angle);
      const result1 = Array.from(v1);

      // Test vec3Drotate
      const result2 = gemm.vec3Drotate([...vector], [...axis], angle, true);

      expect(result1[0]).toBeCloseTo(result2[0], 4);
      expect(result1[1]).toBeCloseTo(result2[1], 4);
      expect(result1[2]).toBeCloseTo(result2[2], 4);
    });
  });

});

// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for dot3Dline3D_x_plane3D function using Bun's built-in test runner
 * Tests intersection calculation between a 3D line and a 3D plane
 */

describe("dot3Dline3D_x_plane3D", () => {
  describe("Basic intersection calculations", () => {
    test("should find intersection of line and plane at origin", () => {
      const dot3D0 = [0, 0, -5];
      const vec3D0 = [0, 0, 1]; // line going up in Z direction
      const vec3Dplane = [0, 0, 1]; // XY plane normal
      const dplane = 0; // plane at Z=0
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should find intersection of line perpendicular to plane", () => {
      const dot3D0 = [1, 2, 0];
      const vec3D0 = [0, 0, 1]; // line going up in Z direction
      const vec3Dplane = [0, 0, 1]; // XY plane normal
      const dplane = 5; // plane at Z=-5
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(-5);
    });

    test("should find intersection with plane at non-zero displacement", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [1, 1, 1]; // diagonal line
      const vec3Dplane = [1, 0, 0]; // YZ plane normal
      const dplane = 3; // plane at X=-3
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(-3);
      expect(result[1]).toBeCloseTo(-3);
      expect(result[2]).toBeCloseTo(-3);
    });

    test("should find intersection of diagonal line through origin plane", () => {
      const dot3D0 = [-1, -1, -1];
      const vec3D0 = [1, 1, 1]; // diagonal direction
      const vec3Dplane = [1, 1, 1]; // plane normal
      const dplane = 0; // plane through origin
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should find no intersection if plane normal and line have 90 degrees angle [1,1,0]", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [1, -1, 0]; // line in XY plane
      const vec3Dplane = [1, 1, 0]; // plane normal in XY plane
      const dplane = 1; // plane equation: x + y = -1
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([]);
    });
  });

  describe("Line parallel to plane (no intersection)", () => {
    test("should return empty array when line is parallel to plane", () => {
      const dot3D0 = [0, 0, 1];
      const vec3D0 = [1, 0, 0]; // line parallel to XY plane
      const vec3Dplane = [0, 0, 1]; // XY plane normal
      const dplane = 0;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([]);
    });

    test("should return empty array when line is parallel to plane with non-zero displacement", () => {
      const dot3D0 = [5, 5, 3];
      const vec3D0 = [1, 1, 0]; // line parallel to plane
      const vec3Dplane = [0, 0, 1]; // plane normal
      const dplane = 5;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([]);
    });

    test("should return empty array when line direction is orthogonal to plane normal", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [2, 3, 0]; // orthogonal to [0, 0, 1]
      const vec3Dplane = [0, 0, 1];
      const dplane = 1;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([]);
    });
  });

  describe("Line starts on plane", () => {
    test("should return starting point when line starts on plane", () => {
      const dot3D0 = [1, 2, 3];
      const vec3D0 = [1, 1, 1]; // any direction
      const vec3Dplane = [1, 0, 0]; // YZ plane normal
      const dplane = -1; // plane at X=1
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([1, 2, 3]);
    });

    test("should return starting point when line starts on origin plane", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [5, 5, 5];
      const vec3Dplane = [1, 1, 1];
      const dplane = 0;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([0, 0, 0]);
    });

    test("should return [] when the line and the plane are paralleled", () => {
      const dot3D0 = [2, 0, 0];
      const vec3D0 = [0, 1, 0];
      const vec3Dplane = [1, 0, 0]; // YZ plane
      const dplane = -2; // plane at X=2
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([]);
    });
  });

  describe("Dimension validation", () => {
    test("should return empty array when dot3D0 is not 3D", () => {
      const dot3D0 = [0, 0];
      const vec3D0 = [1, 1, 1];
      const vec3Dplane = [0, 0, 1];
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3D0 is not 3D", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [1, 1];
      const vec3Dplane = [0, 0, 1];
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3Dplane is not 3D", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [1, 1, 1];
      const vec3Dplane = [0, 0];
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane);
      expect(result).toEqual([]);
    });

    test("should return empty array when dimensions are mixed", () => {
      const dot3D0 = [0, 0, 0, 0];
      const vec3D0 = [1, 1, 1];
      const vec3Dplane = [0, 0, 1];
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane);
      expect(result).toEqual([]);
    });
  });

  describe("Negative coordinates and directions", () => {
    test("should find intersection with negative line direction", () => {
      const dot3D0 = [0, 0, 5];
      const vec3D0 = [0, 0, -1]; // going down
      const vec3Dplane = [0, 0, 1];
      const dplane = 0;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should find intersection with negative plane displacement", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [0, 0, 1];
      const vec3Dplane = [0, 0, 1];
      const dplane = -10; // plane at Z=-10
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(10);
    });

    test("should find intersection starting from negative coordinates", () => {
      const dot3D0 = [-5, -5, -5];
      const vec3D0 = [1, 1, 1];
      const vec3Dplane = [1, 1, 1];
      const dplane = 0;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });

  describe("Scaled vectors and planes", () => {
    test("should find intersection with scaled plane normal", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [1, 0, 0];
      const vec3Dplane = [2, 0, 0]; // scaled normal
      const dplane = -6; // plane at X=3
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(3);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should find intersection with scaled line direction", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [2, 0, 0]; // scaled direction
      const vec3Dplane = [1, 0, 0];
      const dplane = -5; // plane at X=5
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(5);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });

  describe("Complex geometric scenarios", () => {
    test("should find intersection of line through two points with plane", () => {
      // Line from [0,0,0] to [1,1,1]
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [1, 1, 1];
      // Plane: X + Y + Z = 3
      const vec3Dplane = [1, 1, 1];
      const dplane = -3;
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(1);
      expect(result[2]).toBeCloseTo(1);
    });

    test("should find intersection with plane in 3D space at arbitrary position", () => {
      const dot3D0 = [1, 2, 3];
      const vec3D0 = [1, 0, 0]; // moving along X
      const vec3Dplane = [1, 0, 0]; // YZ plane
      const dplane = -7; // plane at X=7
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result[0]).toBeCloseTo(7);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(3);
    });

    test("should find intersection of line with tilted plane", () => {
      const dot3D0 = [0, 0, 0];
      const vec3D0 = [0, 0, 1]; // vertical line
      const vec3Dplane = [1, 1, 0]; // tilted plane normal
      const dplane = -5; // plane equation: X + Y = 5
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane, dplane);
      expect(result).toEqual([]); // line parallel to plane
    });
  });

  describe("Default parameter handling", () => {
    test("should use dplane=0 as default when not provided", () => {
      const dot3D0 = [0, 0, -5];
      const vec3D0 = [0, 0, 1];
      const vec3Dplane = [0, 0, 1];
      const result = gemm.dot3Dline3D_x_plane3D(dot3D0, vec3D0, vec3Dplane);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });
});

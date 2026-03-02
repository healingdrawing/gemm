// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for plane3D_dot3Dnormal function using Bun's built-in test runner
 * Tests 3D plane equation calculation (a, b, c, d) from a point and normal vector
 * The normal vector is normalized internally, so results use unit normal vectors
 * Plane equation: ax + by + cz + d = 0, where (a, b, c) is the normalized normal
 */

describe("plane3D_dot3Dnormal", () => {
  describe("Valid plane calculations with unit normals", () => {
    test("should calculate plane equation for point [1,0,0] with normal [1,0,0]", () => {
      const dot3D = [1, 0, 0];
      const vec3D = [1, 0, 0]; // already unit
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(-1, 5); // -(1*1 + 0*0 + 0*0) = -1
    });

    test("should calculate plane equation for point [0,0,0] with normal [1,1,1]", () => {
      const dot3D = [0, 0, 0];
      const vec3D = [1, 1, 1];
      const magnitude = Math.sqrt(3);
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(1 / magnitude, 5);
      expect(result[1]).toBeCloseTo(1 / magnitude, 5);
      expect(result[2]).toBeCloseTo(1 / magnitude, 5);
      expect(result[3]).toBeCloseTo(0, 5); // plane through origin
    });

    test("should calculate plane equation for point [1,2,3] with normal [1,0,0]", () => {
      const dot3D = [1, 2, 3];
      const vec3D = [1, 0, 0]; // already unit
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(-1, 5); // -(1*1) = -1
    });

    test("should calculate plane equation for point [2,3,4] with normal [2,3,4]", () => {
      const dot3D = [2, 3, 4];
      const vec3D = [2, 3, 4];
      const magnitude = Math.sqrt(4 + 9 + 16); // √29
      const nx = 2 / magnitude;
      const ny = 3 / magnitude;
      const nz = 4 / magnitude;
      const d = -(2 * nx + 3 * ny + 4 * nz);
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(nx, 5);
      expect(result[1]).toBeCloseTo(ny, 5);
      expect(result[2]).toBeCloseTo(nz, 5);
      expect(result[3]).toBeCloseTo(d, 5);
    });

    test("should calculate plane equation for point [1,1,1] with normal [1,1,1]", () => {
      const dot3D = [1, 1, 1];
      const vec3D = [1, 1, 1];
      const magnitude = Math.sqrt(3);
      const n = 1 / magnitude;
      const d = -(1 * n + 1 * n + 1 * n); // -3/√3 = -√3
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(n, 5);
      expect(result[1]).toBeCloseTo(n, 5);
      expect(result[2]).toBeCloseTo(n, 5);
      expect(result[3]).toBeCloseTo(d, 5);
    });

    test("should calculate plane equation with negative normal vector", () => {
      const dot3D = [1, 0, 0];
      const vec3D = [-1, 0, 0]; // will normalize to [-1, 0, 0]
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(-1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(1, 5); // -(-1*1) = 1
    });

    test("should calculate plane equation with mixed sign coordinates", () => {
      const dot3D = [-1, 2, -3];
      const vec3D = [1, -1, 1];
      const magnitude = Math.sqrt(1 + 1 + 1); // √3
      const nx = 1 / magnitude;
      const ny = -1 / magnitude;
      const nz = 1 / magnitude;
      const d = -(-1 * nx + 2 * ny - 3 * nz);
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(nx, 5);
      expect(result[1]).toBeCloseTo(ny, 5);
      expect(result[2]).toBeCloseTo(nz, 5);
      expect(result[3]).toBeCloseTo(d, 5);
    });

    test("should normalize very large normal vector", () => {
      const dot3D = [1, 0, 0];
      const vec3D = [1000, 0, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(-1, 5);
    });

    test("should normalize very small normal vector", () => {
      const dot3D = [0.001, 0.001, 0.001];
      const vec3D = [0.001, 0, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(1, 5); // normalized
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(-0.001, 5); // -(0.001 * 1)
    });
  });

  describe("Invalid input handling", () => {
    test("should return empty array when dot3D has wrong length (2D)", () => {
      const dot3D = [1, 0];
      const vec3D = [1, 0, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3D has wrong length (4D)", () => {
      const dot3D = [1, 0, 0, 1];
      const vec3D = [1, 0, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3D has wrong length (2D)", () => {
      const dot3D = [1, 0, 0];
      const vec3D = [1, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3D has wrong length (4D)", () => {
      const dot3D = [1, 0, 0];
      const vec3D = [1, 0, 0, 1];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when normal vector is zero [0,0,0]", () => {
      const dot3D = [1, 2, 3];
      const vec3D = [0, 0, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when both inputs have wrong length", () => {
      const dot3D = [1, 0];
      const vec3D = [1, 0];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result).toEqual([]);
    });
  });

  describe("Edge cases and special planes", () => {
    test("should handle plane parallel to XY (normal along Z)", () => {
      const dot3D = [0, 0, 5];
      const vec3D = [0, 0, 1]; // already unit
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(1, 5);
      expect(result[3]).toBeCloseTo(-5, 5); // z = 5
    });

    test("should handle plane parallel to XZ (normal along Y)", () => {
      const dot3D = [0, 3, 0];
      const vec3D = [0, 1, 0]; // already unit
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(1, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(-3, 5); // y = 3
    });

    test("should handle plane parallel to YZ (normal along X)", () => {
      const dot3D = [2, 0, 0];
      const vec3D = [1, 0, 0]; // already unit
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(1, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(-2, 5); // x = 2
    });

    test("should handle plane through origin with arbitrary normal", () => {
      const dot3D = [0, 0, 0];
      const vec3D = [3, 4, 0];
      const magnitude = 5; // 3-4-5 triangle
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(3 / magnitude, 5);
      expect(result[1]).toBeCloseTo(4 / magnitude, 5);
      expect(result[2]).toBeCloseTo(0, 5);
      expect(result[3]).toBeCloseTo(0, 5); // d = 0 for plane through origin
    });

    test("should handle negative coordinates with normalized normal", () => {
      const dot3D = [-1, -2, -3];
      const vec3D = [1, 1, 1];
      const magnitude = Math.sqrt(3);
      const n = 1 / magnitude;
      const d = -(-1 * n - 2 * n - 3 * n); // -(-6/√3) = 6/√3 = 2√3
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(n, 5);
      expect(result[1]).toBeCloseTo(n, 5);
      expect(result[2]).toBeCloseTo(n, 5);
      expect(result[3]).toBeCloseTo(d, 5);
    });

    test("should handle large coordinate values", () => {
      const dot3D = [1000, 2000, 3000];
      const vec3D = [1, 1, 1];
      const magnitude = Math.sqrt(3);
      const n = 1 / magnitude;
      const d = -(1000 * n + 2000 * n + 3000 * n); // -6000/√3
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      expect(result[0]).toBeCloseTo(n, 5);
      expect(result[1]).toBeCloseTo(n, 5);
      expect(result[2]).toBeCloseTo(n, 5);
      expect(result[3]).toBeCloseTo(d, 5);
    });
  });

  describe("Normalized vector properties", () => {
    test("normal vector should have magnitude 1", () => {
      const dot3D = [5, 7, 9];
      const vec3D = [2, 3, 4];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      const magnitude = Math.sqrt(result[0]**2 + result[1]**2 + result[2]**2);
      expect(magnitude).toBeCloseTo(1, 5);
    });

    test("plane equation should be satisfied at input point", () => {
      const dot3D = [1, 2, 3];
      const vec3D = [1, 1, 1];
      const result = gemm.plane3D_dot3Dnormal(dot3D, vec3D);
      const [a, b, c, d] = result;
      const pointValue = a * dot3D[0] + b * dot3D[1] + c * dot3D[2] + d;
      expect(pointValue).toBeCloseTo(0, 5); // point should satisfy plane equation
    });

    test("different magnitudes of same direction should produce same plane", () => {
      const dot3D = [1, 2, 3];
      const vec3D1 = [1, 1, 1];
      const vec3D2 = [5, 5, 5];
      const result1 = gemm.plane3D_dot3Dnormal(dot3D, vec3D1);
      const result2 = gemm.plane3D_dot3Dnormal(dot3D, vec3D2);
      expect(result1[0]).toBeCloseTo(result2[0], 5);
      expect(result1[1]).toBeCloseTo(result2[1], 5);
      expect(result1[2]).toBeCloseTo(result2[2], 5);
      expect(result1[3]).toBeCloseTo(result2[3], 5);
    });
  });
});

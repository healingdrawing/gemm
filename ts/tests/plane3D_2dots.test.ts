// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for plane3D_2dots function using Bun's built-in test runner
 * Tests 3D plane equation calculation from two distinct points
 * The plane is perpendicular to the vector connecting the two points
 * The normal vector is the vector from dot3D to dot3Da, normalized to unit length
 * Where (a, b, c) is the normal vector and d is the displacement from origin
 */

describe("plane3D_2dots", () => {
  describe("Valid plane calculations with standard points", () => {
    test("should calculate plane perpendicular to X axis through origin", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [1,0,0]
      // Normalized: [1,0,0]
      // d = -(1*0 + 0*0 + 0*0) = 0
      expect(result).toEqual([1, 0, 0, -0]);
    });

    test("should calculate plane perpendicular to Y axis through origin", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0, 1, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [0,1,0]
      // Normalized: [0,1,0]
      // d = 0
      expect(result).toEqual([0, 1, 0, -0]);
    });

    test("should calculate plane perpendicular to Z axis through origin", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0, 0, 1];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [0,0,1]
      // Normalized: [0,0,1]
      // d = 0
      expect(result).toEqual([0, 0, 1, -0]);
    });
  });

  describe("Valid plane calculations with arbitrary points", () => {
    test("should calculate plane from point [1,0,0] with normal axis to [2,0,0]", () => {
      const dot3D = [1, 0, 0];
      const dot3Da = [2, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [1,0,0]
      // Normalized: [1,0,0]
      // d = -(1*1 + 0*0 + 0*0) = -1
      expect(result).toEqual([1, 0, 0, -1]);
    });

    test("should calculate plane from point [0,2,0] with normal axis to [0,5,0]", () => {
      const dot3D = [0, 2, 0];
      const dot3Da = [0, 5, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [0,3,0]
      // Normalized: [0,1,0]
      // d = -(0*0 + 1*2 + 0*0) = -2
      expect(result).toEqual([0, 1, 0, -2]);
    });

    test("should calculate plane from point [1,1,1] with normal axis to [2,2,2]", () => {
      const dot3D = [1, 1, 1];
      const dot3Da = [2, 2, 2];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [1,1,1]
      // Norm = sqrt(3)
      // Normalized: [1/sqrt(3), 1/sqrt(3), 1/sqrt(3)]
      // d = -(1/sqrt(3)*1 + 1/sqrt(3)*1 + 1/sqrt(3)*1) = -3/sqrt(3) = -sqrt(3)
      const norm = Math.sqrt(3);
      expect(result[0]).toBeCloseTo(1 / norm);
      expect(result[1]).toBeCloseTo(1 / norm);
      expect(result[2]).toBeCloseTo(1 / norm);
      expect(result[3]).toBeCloseTo(-Math.sqrt(3));
    });

    test("should calculate plane from point [1,2,3] with normal axis to [4,6,8]", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [4, 6, 8];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [3,4,5]
      // Norm = sqrt(9 + 16 + 25) = sqrt(50) = 5*sqrt(2)
      // Normalized: [3/(5*sqrt(2)), 4/(5*sqrt(2)), 5/(5*sqrt(2))]
      // d = -(3/(5*sqrt(2))*1 + 4/(5*sqrt(2))*2 + 5/(5*sqrt(2))*3)
      //   = -(3 + 8 + 15)/(5*sqrt(2)) = -26/(5*sqrt(2))
      const norm = Math.sqrt(50);
      expect(result[0]).toBeCloseTo(3 / norm);
      expect(result[1]).toBeCloseTo(4 / norm);
      expect(result[2]).toBeCloseTo(5 / norm);
      expect(result[3]).toBeCloseTo(-26 / norm);
    });

    test("should handle negative direction vector", () => {
      const dot3D = [2, 0, 0];
      const dot3Da = [0, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [-2,0,0]
      // Normalized: [-1,0,0]
      // d = -((-1)*2 + 0*0 + 0*0) = 2
      expect(result).toEqual([-1, 0, 0, 2]);
    });

    test("should handle mixed sign coordinates", () => {
      const dot3D = [-1, 2, -3];
      const dot3Da = [2, -1, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [3,-3,3]
      // Norm = sqrt(9 + 9 + 9) = 3*sqrt(3)
      // Normalized: [1/sqrt(3), -1/sqrt(3), 1/sqrt(3)]
      // d = -(1/sqrt(3)*(-1) + (-1/sqrt(3))*2 + 1/sqrt(3)*(-3))
      //   = -(-1 - 2 - 3)/sqrt(3) = 6/sqrt(3) = 2*sqrt(3)
      const norm = Math.sqrt(3);
      expect(result[0]).toBeCloseTo(1 / norm);
      expect(result[1]).toBeCloseTo(-1 / norm);
      expect(result[2]).toBeCloseTo(1 / norm);
      expect(result[3]).toBeCloseTo(2 * Math.sqrt(3));
    });
  });

  describe("Invalid input - wrong array sizes", () => {
    test("should return empty array when dot3D has length 2", () => {
      const dot3D = [1, 0];
      const dot3Da = [1, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3D has length 4", () => {
      const dot3D = [1, 0, 0, 1];
      const dot3Da = [1, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3Da has length 2", () => {
      const dot3D = [1, 0, 0];
      const dot3Da = [1, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3Da has length 4", () => {
      const dot3D = [1, 0, 0];
      const dot3Da = [1, 0, 0, 1];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });

    test("should return empty array when both inputs have different lengths", () => {
      const dot3D = [1, 0];
      const dot3Da = [1, 0, 0, 1];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });
  });

  describe("Invalid input - identical points", () => {
    test("should return empty array when dot3D equals dot3Da", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [1, 2, 3];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });

    test("should return empty array when both are origin", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });

    test("should return empty array when both have same negative coordinates", () => {
      const dot3D = [-5, -10, -15];
      const dot3Da = [-5, -10, -15];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result).toEqual([]);
    });
  });

  describe("Edge cases", () => {
    test("should handle very small distance between points", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0.001, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
      expect(result[3]).toBeCloseTo(0);
    });

    test("should handle large coordinate values", () => {
      const dot3D = [1000, 0, 0];
      const dot3Da = [2000, 0, 0];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [1000,0,0]
      // Normalized: [1,0,0]
      // d = -(1*1000 + 0*0 + 0*0) = -1000
      expect(result).toEqual([1, 0, 0, -1000]);
    });

    test("should handle diagonal vector with large magnitude", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1000, 1000, 1000];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [1000,1000,1000]
      // Norm = 1000*sqrt(3)
      // Normalized: [1/sqrt(3), 1/sqrt(3), 1/sqrt(3)]
      const norm = Math.sqrt(3);
      expect(result[0]).toBeCloseTo(1 / norm);
      expect(result[1]).toBeCloseTo(1 / norm);
      expect(result[2]).toBeCloseTo(1 / norm);
      expect(result[3]).toBeCloseTo(0);
    });

    test("should handle fractional coordinates", () => {
      const dot3D = [0.5, 0.5, 0.5];
      const dot3Da = [1.5, 0.5, 0.5];
      const result = gemm.plane3D_2dots(dot3D, dot3Da);
      // Vector: [1,0,0]
      // Normalized: [1,0,0]
      // d = -(1*0.5 + 0*0.5 + 0*0.5) = -0.5
      expect(result).toEqual([1, 0, 0, -0.5]);
    });
  });

});
